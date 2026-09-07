return {
    {
        prefix = 'f',
        desc = 'function (anonymous)',
        body = {
            '${1:local }function ${2:name}(${3})',
            '    ${SELECTED}$0',
            'end',
        },
    },
    {
        prefix = 'if',
        desc = 'if statement',
        body = {
            'if ${1:condition} then',
            '    ${SELECTED}$0',
            'end',
        },
    },
    {
        prefix = 'ife',
        desc = 'if-else statement',
        body = {
            'if ${1:condition} then',
            '    ${SELECTED}$2',
            'else',
            '    $0',
            'end',
        },
    },
    {
        prefix = 'forn',
        desc = 'for loop (numeric)',
        body = {
            'for ${1:index} = ${2:1}, ${3:count} do',
            '    ${SELECTED}$0',
            'end',
        },
    },
    {
        prefix = 'fori',
        desc = 'ipairs iteration',
        body = {
            'for ${1:index}, ${2:value} in ipairs(${3:table}) do',
            '    ${SELECTED}$0',
            'end',
        },
    },
    {
        prefix = 'forp',
        desc = 'pairs iteration',
        body = {
            'for ${1:key}, ${2:value} in pairs(${3:table}) do',
            '    ${SELECTED}$0',
            'end',
        },
    },
}
