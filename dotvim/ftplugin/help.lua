-- No need for this on help files :)
vim.b.miniindentscope_disable = true
-- Load the helpful plugin "on demand". Set the variable so it automatically
-- triggers on CursorMoved, enable the plugin, the set it up manually (because
-- its set up on the FileType event, which is when this is running).
vim.b.helpful = 1
vim.cmd.packadd "helpful"
vim.fn['helpful#setup']()
