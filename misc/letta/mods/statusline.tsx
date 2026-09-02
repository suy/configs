import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { basename } from "node:path";

const execFileAsync = promisify(execFile);

/**
 * Format token counts compactly so the statusline is less likely to overflow.
 * Examples: 950 -> "950", 12_400 -> "12.4k", 1_250_000 -> "1.3m".
 */
function formatTokens(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}m`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export default function activate(letta) {
  // Panels are available in the interactive Letta Code UI, but not every
  // runtime surface. Exiting here makes the mod safe on unsupported surfaces.
  if (!letta.capabilities.ui.panels) return;

  // Git and cwd are external process state, so we cache them and refresh them
  // on a timer. The render function itself must stay synchronous and pure.
  let branch = "";
  let cwdName = "";

  const panel = letta.ui.openPanel({
    id: "statusline",
    order: 0, // The primary line below the input; replaces agent · model.

    /**
     * `contextWindow` comes from the full live ModContext. This works for
     * Cloud as well as Local when Letta receives context usage statistics.
     * It does not require the Local-only llm_start/llm_end events.
     */
    render: ({ width, agent, contextWindow, row, chalk }) => {
      const parts: string[] = [];

      parts.push(chalk.cyan(agent.name ?? "Letta"));
      if (branch) parts.push(chalk.green(branch));
      if (cwdName) parts.push(chalk.dim(cwdName));

      const remainingPct = contextWindow.remainingPercentage;
      if (contextWindow.size > 0 && remainingPct !== null) {
        /**
         * The mod API exposes an exact window size but a rounded percentage,
         * not the raw current-context token count. Multiplying them therefore
         * gives an approximate remaining-token count, marked with "~".
         */
        const approximateRemaining = Math.round(
          contextWindow.size * remainingPct / 100,
        );
        const label =
          `~${formatTokens(approximateRemaining)} (${remainingPct}% left)`;

        parts.push(
          remainingPct > 25 ? chalk.dim(label) : chalk.yellow(label),
        );
      }

      /**
       * These are cumulative session input/output totals. They are usage
       * counters, not the size of the currently compiled context window.
       */
      if (
        contextWindow.totalInputTokens > 0 ||
        contextWindow.totalOutputTokens > 0
      ) {
        parts.push(
          chalk.dim(
            `${formatTokens(contextWindow.totalInputTokens)} in / ` +
            `${formatTokens(contextWindow.totalOutputTokens)} out`,
          ),
        );
      }

      return row(parts.join(chalk.dim(" · ")), "", width);
    },
  });

  const updateProjectInfo = async () => {
    cwdName = basename(process.cwd());

    try {
      const { stdout } = await execFileAsync(
        "git",
        ["branch", "--show-current"],
        { cwd: process.cwd() },
      );
      branch = stdout.trim();
    } catch {
      // Outside a Git repository, omit the branch instead of showing an error.
      branch = "";
    }

    // External state changed, so ask the host to render the panel again.
    panel.update();
  };

  void updateProjectInfo();
  const projectTimer = setInterval(updateProjectInfo, 30_000);

  // Letta calls this disposer on /reload or shutdown.
  return () => {
    clearInterval(projectTimer);
    panel.close();
  };
}
