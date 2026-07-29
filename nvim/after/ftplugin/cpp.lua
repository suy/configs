vim.bo.commentstring='// %s'

-- See details in *cinoptions-values*, or *cino-=*, *cino-g*, etc.
-- Place case labels 0 characters from the indent of the switch().
vim.opt_local.cinoptions:append({':0'})
-- In the header public/private/protected 0 characters from the indent.
vim.opt_local.cinoptions:append({'g0'})
-- Indent inside C++ namespace N characters extra compared to a normal block.
-- setlocal cinoptions+=N-s
vim.opt_local.cinoptions:append({'N-s'})
-- For Java anonymous classes, but works for C++'s lambdas as well.
vim.opt_local.cinoptions:append({'j1'})
