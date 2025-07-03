--
-- Prelude is anything that has to be done early in the configuration because is
-- a dependency of something that comes later.
--
-- An easy example are the leader keys: global variables that need to be defined
-- first to be the "prefix" of some mappings. If it gets changed later, the
-- mappings would have to be redone!
--
-- A more complex one is detecting if a certain tool is installed, so the editor
-- can enable some features conditionally. Likewise with detecting the OS,
-- external settings (keybard, monitor related), etc.

-- A global variable reserved as a sort of convenience API for some of the
-- configuration, like when setting repeatable mappings in `init-mappings.lua`.
Init = {}

vim.g.mapleader = ','
vim.g.maplocalleader = '_'

