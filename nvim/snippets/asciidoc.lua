local result = {}

table.insert(result, {
    prefix = 'admonition',
    desc = 'Admonition block (NOTE, TIP, IMPORTANT, CAUTION, WARNING)',
    body = {
        '[${1|NOTE,TIP,IMPORTANT,CAUTION,WARNING|}]',
        '====',
        '${SELECTED}$0',
        '====',
    },
})

table.insert(result, {
    prefix = 'code',
    desc = 'Code block with `----`',
    body = {
        '[source,${1:language}]',
        '.${2:title}',
        '----',
        '${SELECTED}$0',
        '----',
    },
})

table.insert(result, {
    prefix = 'collapsible',
    desc = 'Collapsible block',
    body = {
        '.${1:title}',
        '[%collapsible]',
        '====',
        '${SELECTED}$0',
        '====',
    },
})

table.insert(result, {
    prefix = 'definitions',
    desc = 'Horizontal definition list with label/item widths',
    body = {
        '[horizontal,labelwidth=${1:25},itemwidth=${2:75}]',
        '${3:term}:: ${0:description}',
    },
})

table.insert(result, {
    prefix = 'dlist',
    desc = 'Horizontal definition list',
    body = {
        '[horizontal]',
        '${1:term}:: ${0:description}',
    },
})

table.insert(result, {
    prefix = 'example',
    desc = 'Example block',
    body = {
        '.${1:title}',
        '====',
        '${SELECTED}$0',
        '====',
    },
})

table.insert(result, {
    prefix = 'id-asciidoctor',
    desc = 'ID in Asciidoctor-only extension',
    body = '[#${1:id}]',
})

table.insert(result, {
    prefix = 'id-traditional',
    desc = 'ID in traditional AsciiDoc notation',
    body = '[[${1:id}]]',
})

table.insert(result, {
    prefix = 'quote',
    desc = 'Quote block with attribution',
    body = {
        '[quote, ${1:author}]',
        '____',
        '${SELECTED}$0',
        '____',
    },
})

table.insert(result, {
    prefix = 'role-asciidoctor',
    desc = 'Role in Asciidoctor-only extension',
    body = '[.${1:role}]',
})

table.insert(result, {
    prefix = 'role-traditional',
    desc = 'Role in traditional AsciiDoc notation',
    body = '[role="${1:role}"]',
})

table.insert(result, {
    prefix = 'sidebar',
    desc = 'Sidebar block',
    body = {
        '.${1:title}',
        '****',
        '${SELECTED}$0',
        '****',
    },
})

table.insert(result, {
    prefix = 'stem',
    desc = 'STEM block (LaTeX math)',
    body = {
        '[stem]',
        '++++',
        '${SELECTED}$0',
        '++++',
    },
})

table.insert(result, {
    prefix = 'toc',
    desc = 'Document header attributes',
    body = {
        ':toc: right',
        ':toc-title:',
        ':toclevels: 3',
        ':sectanchors:',
        ':sectnums:',
        ':idprefix:',
        ':source-highlighter: highlight.js',
        '$0',
    },
})

return result
