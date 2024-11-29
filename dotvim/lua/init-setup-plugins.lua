------------------------------------------------------------------------------
-- MiniBracketed
------------------------------------------------------------------------------
-- TODO: A lot of overlap with unimpaired, so needs reviewing. Most seems the
-- same, but perhaps is worth considering some, like move to next diagnostic (if
-- the new core mapping is different). Also one to move to a next/prev
-- indentation, if it complements ai/indentscope.


------------------------------------------------------------------------------
-- MiniFiles
------------------------------------------------------------------------------
require('mini.files').setup()

------------------------------------------------------------------------------
-- MiniIcons
------------------------------------------------------------------------------
require('mini.icons').setup({style='ascii'})


------------------------------------------------------------------------------
-- MiniIndentscope
------------------------------------------------------------------------------
require('mini.indentscope').setup()


------------------------------------------------------------------------------
-- MiniNotify
------------------------------------------------------------------------------
require('mini.notify').setup()
-- TODO: make a wrapper function that stores the message in a ring buffer, then
-- passes it to the make_notify function. Then add a function that displays the
-- messages, like :Messages does.
vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 10000 } -- The default is 5s, so double it.
})

