// ==UserScript==
// @name        Discord: keyboard mute / mark-read for current server
// @namespace   suy.discord-server-keys
// @version     0.4.1
// @description Alt+Shift+M opens a menu to mute the current server for a chosen duration (Discord's five defaults plus 2, 3 and 7 days). Alt+Shift+R marks the current server as read. Keys are matched by physical position (event.code), so they are layout independent.
// @author      Alejandro Exojo Piqueras
// @match       https://discord.com/channels/*
// @grant       none
// @noframes
// @run-at      document-start
// @license     MIT
// ==/UserScript==

// Why this exists: Firefox claims Shift+Esc for about:processes before the
// page ever sees it (bug 1806272, no about:config toggle), and Discord offers
// no keyboard path to mute a server — its custom keybinds only cover voice
// and navigation.

// v0.4.0: REST mode. Lessons from v0.2–v0.3 forensics: Discord's bundle
// contains ~54 i18n modules whose accessor functions mirror Discord's own API
// method names (getGuild, isMuted, markGuildAsRead,
// updateGuildNotificationSettings…), so webpack name-matching cannot
// distinguish actions from message lookups, and cache order decides which
// impostor answers first. Internal-module hunting is gone. Both actions now
// call Discord's REST API directly — the same endpoints the client itself
// sends; the UI follows via gateway events. The single internal still used is
// the auth token, found by output shape (three dot-separated segments), which
// message accessors cannot fake. Mute success is verified with a GET
// round-trip before the toast claims anything.

(function () {
  'use strict';

  const LOG_PREFIX = '[discord-server-keys]';
  const API = '/api/v9';

  console.info(`${LOG_PREFIX} v0.4.1 attached (REST mode)`);

  // ---------------------------------------------------------------- webpack
  // Capture the bundle's require by pushing a fake chunk. Used ONLY to find
  // the token module; everything else goes through REST.

  let webpackRequire = null;

  // Violentmonkey with @grant none normally runs in page context, but keep
  // the Firefox sandbox escape hatches: page globals may hide behind
  // wrappedJSObject (Xray) or be reachable via unsafeWindow.
  function windowRoots() {
    const roots = [];
    if (typeof unsafeWindow !== 'undefined') roots.push(unsafeWindow);
    const unwrapped = window.wrappedJSObject || window;
    roots.push(unwrapped);
    if (window !== unwrapped) roots.push(window);
    return roots;
  }

  function captureWebpack() {
    if (webpackRequire) return webpackRequire;
    for (const root of windowRoots()) {
      try {
        const chunkKeys = Object.keys(root).filter((key) => /^webpackChunk/.test(key));
        const name = chunkKeys.find((key) => key.includes('discord')) || chunkKeys[0];
        if (!name) continue;
        root[name].push([[Math.random()], {}, (requireFunction) => { webpackRequire = requireFunction; }]);
        if (webpackRequire) {
          console.info(`${LOG_PREFIX} webpack captured via ${name}`);
          return webpackRequire;
        }
      } catch { /* try the next root */ }
    }
    return null;
  }

  let capturePolls = 0;
  const capturePoll = window.setInterval(() => {
    if (captureWebpack() || ++capturePolls > 120) {
      window.clearInterval(capturePoll);
      if (!webpackRequire) console.error(`${LOG_PREFIX} no webpack chunk global found; actions will fail`);
    }
  }, 500);

  // The token module: among all getToken exports, the one whose result looks
  // like a Discord token (three dot-separated base64url segments). i18n
  // accessors named getToken return non-strings and are rejected by shape.
  let tokenModuleCache;
  function getTokenModule() {
    if (tokenModuleCache !== undefined) return tokenModuleCache;
    tokenModuleCache = null;
    if (!webpackRequire || !webpackRequire.c) return tokenModuleCache;
    for (const id of Object.keys(webpackRequire.c)) {
      const exports = webpackRequire.c[id] && webpackRequire.c[id].exports;
      if (!exports || typeof exports.getToken !== 'function') continue;
      try {
        const token = exports.getToken();
        if (typeof token === 'string' && /^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]{20,}$/.test(token)) {
          tokenModuleCache = exports;
          break;
        }
      } catch { /* foreign module: anything can throw */ }
    }
    return tokenModuleCache;
  }

  // ------------------------------------------------------------------- REST

  async function api(method, path, body) {
    const tokenModule = getTokenModule();
    if (!tokenModule) {
      console.error(`${LOG_PREFIX} no usable token module; cannot call ${method} ${path}`);
      return null;
    }
    try {
      return await window.fetch(API + path, {
        method,
        headers: { 'Content-Type': 'application/json', authorization: tokenModule.getToken() },
        body: body === undefined ? undefined : JSON.stringify(body),
      });
    } catch (error) {
      console.error(`${LOG_PREFIX} ${method} ${path} threw`, error);
      return null;
    }
  }

  // ------------------------------------------------------------- primitives

  function currentGuildId() {
    const segments = window.location.pathname.split('/');
    // Path shape: /channels/<guildId>/<channelId>; '@me' is the DMs view.
    const guildId = segments[2];
    return guildId && guildId !== '@me' ? guildId : null;
  }

  function showToast(message, isError = false) {
    document.getElementById('server-keys-toast')?.remove();
    const toast = document.createElement('div');
    toast.id = 'server-keys-toast';
    toast.textContent = message;
    Object.assign(toast.style, {
      position: 'fixed',
      left: '50%',
      bottom: '24px',
      transform: 'translateX(-50%)',
      padding: '8px 14px',
      borderRadius: '6px',
      background: isError ? '#8c2f2f' : '#2b2d31',
      color: 'white',
      font: '13px system-ui, sans-serif',
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.4)',
      zIndex: '99999',
    });
    document.body.appendChild(toast);
    window.setTimeout(() => toast.remove(), 3000);
  }

  // ------------------------------------------------------------- mute menu

  // Seconds; -1 means "until I turn it back on". The first five are Discord's
  // native durations; 2/3/7 days are the additions. end_time is sent
  // precomputed alongside selected_time_window.
  const MUTE_DURATIONS = [
    { label: '15 minutes',              seconds: 900 },
    { label: '1 hour',                  seconds: 3600 },
    { label: '3 hours',                 seconds: 10800 },
    { label: '8 hours',                 seconds: 28800 },
    { label: '24 hours',                seconds: 86400 },
    { label: '2 days',                  seconds: 172800 },
    { label: '3 days',                  seconds: 259200 },
    { label: '7 days',                  seconds: 604800 },
    { label: 'Until I turn it back on', seconds: -1 },
  ];

  function muteConfigFor(seconds) {
    return seconds < 0
      ? { selected_time_window: -1, end_time: null }
      : { selected_time_window: seconds, end_time: new Date(Date.now() + seconds * 1000).toISOString() };
  }

  async function setServerMute(guildId, mute, seconds, label) {
    const payload = mute
      ? { muted: true, mute_config: muteConfigFor(seconds) }
      : { muted: false };
    const patched = await api('PATCH', `/users/@me/guilds/${guildId}/settings`, payload);
    if (!patched || !patched.ok) {
      showToast(mute ? 'Mute failed' : 'Unmute failed', true);
      return;
    }
    // Server confirmation before claiming success. The PATCH response
    // echoes the updated settings; if it does not, poll the GET — user
    // settings propagate with a short delay, and an immediate GET can still
    // answer the old value (observed as a false "did not stick").
    let verified = !mute; // unmute: 2xx is confirmation enough
    if (mute) {
      const sleep = (ms) => new Promise((resolve) => { window.setTimeout(resolve, ms); });
      try { verified = (await patched.json()).muted === true; } catch { }
      for (let attempt = 0; !verified && attempt < 3; attempt++) {
        await sleep(700);
        const check = await api('GET', `/users/@me/guilds/${guildId}/settings`);
        if (check && check.ok) {
          try { verified = (await check.json()).muted === true; } catch { }
        }
      }
    }
    if (!verified) {
      showToast('Mute did not stick (server did not confirm)', true);
      return;
    }
    showToast(seconds < 0
      ? 'Server muted until you turn it back on'
      : `Server muted for ${label}`);
  }

  async function markServerAsRead(guildId) {
    const response = await api('POST', `/guilds/${guildId}/ack`, {});
    if (response && response.ok) {
      showToast('Server marked as read');
    } else {
      const status = response ? response.status : 'no connection';
      showToast(`Mark as read failed (HTTP ${status})`, true);
    }
  }

  async function openMuteMenu() {
    if (document.getElementById('server-keys-menu')) {
      closeMenu();
      return;
    }
    const guildId = currentGuildId();
    if (!guildId) {
      showToast('No server focused (this is the direct messages view)');
      return;
    }

    // One GET decides whether the Unmute item appears; no store hunting.
    let muted = false;
    const check = await api('GET', `/users/@me/guilds/${guildId}/settings`);
    if (check && check.ok) {
      try { muted = (await check.json()).muted === true; } catch { }
    }

    const items = MUTE_DURATIONS.map((duration, index) => ({
      hint: String(index + 1),
      label: duration.label,
      activate: () => setServerMute(guildId, true, duration.seconds, duration.label),
    }));
    if (muted) {
      items.push({ hint: 'u', label: 'Unmute now', activate: () => setServerMute(guildId, false) });
    }

    const overlay = document.createElement('div');
    overlay.id = 'server-keys-menu';
    Object.assign(overlay.style, {
      position: 'fixed',
      inset: '0',
      zIndex: '99999',
      background: 'rgba(0, 0, 0, 0.5)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
    });

    const panel = document.createElement('div');
    Object.assign(panel.style, {
      background: '#2b2d31',
      borderRadius: '8px',
      padding: '12px',
      minWidth: '280px',
      boxShadow: '0 8px 24px rgba(0, 0, 0, 0.5)',
      color: 'white',
      font: '14px system-ui, sans-serif',
    });

    const title = document.createElement('div');
    title.textContent = 'Mute current server';
    Object.assign(title.style, { fontWeight: '600', marginBottom: '8px' });
    panel.appendChild(title);

    // Invisible but focusable: while it holds focus, Vimium stays in insert
    // mode and passes our keys through untouched.
    const input = document.createElement('input');
    Object.assign(input.style, {
      position: 'absolute',
      opacity: '0',
      width: '1px',
      height: '1px',
      border: 'none',
      padding: '0',
    });
    panel.appendChild(input);

    let selectedIndex = 0;
    const rows = items.map((item, index) => {
      const row = document.createElement('div');
      row.textContent = `${item.hint}. ${item.label}`;
      Object.assign(row.style, {
        padding: '6px 10px',
        borderRadius: '4px',
        cursor: 'pointer',
        whiteSpace: 'pre',
      });
      row.addEventListener('click', () => choose(index));
      row.addEventListener('mousemove', () => setSelection(index));
      panel.appendChild(row);
      return row;
    });

    function setSelection(index) {
      selectedIndex = index;
      rows.forEach((row, rowIndex) => {
        row.style.background = rowIndex === selectedIndex ? '#404249' : 'transparent';
      });
    }

    function choose(index) {
      closeMenu();
      items[index].activate();
    }

    input.addEventListener('keydown', (event) => {
      event.stopPropagation();
      if (event.key === 'Escape') { closeMenu(); return; }
      if (event.key === 'ArrowDown') {
        setSelection(Math.min(selectedIndex + 1, items.length - 1));
        return;
      }
      if (event.key === 'ArrowUp') {
        setSelection(Math.max(selectedIndex - 1, 0));
        return;
      }
      if (event.key === 'Enter') { choose(selectedIndex); return; }
      const hintedIndex = items.findIndex((item) => item.hint === event.key);
      if (hintedIndex !== -1) choose(hintedIndex);
    });

    overlay.addEventListener('mousedown', (event) => {
      if (event.target === overlay) closeMenu();
    });

    overlay.appendChild(panel);
    document.body.appendChild(overlay);
    setSelection(0);
    input.focus();
  }

  function closeMenu() {
    document.getElementById('server-keys-menu')?.remove();
  }

  // ------------------------------------------------------------ keybinding

  window.addEventListener('keydown', (event) => {
    if (!event.altKey || !event.shiftKey || event.ctrlKey || event.metaKey) return;
    if (event.repeat || event.isComposing) return;
    // event.code: the physical key, independent of the active layout.
    if (event.code === 'KeyM') {
      event.preventDefault();
      event.stopPropagation();
      openMuteMenu();
    } else if (event.code === 'KeyR') {
      event.preventDefault();
      event.stopPropagation();
      const guildId = currentGuildId();
      if (!guildId) {
        showToast('No server focused (this is the direct messages view)');
        return;
      }
      markServerAsRead(guildId);
    }
  }, true);
})();
