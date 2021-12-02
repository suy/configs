setlocal commentstring=//%s

" See details in *cinoptions-values*, or *cino-=*, *cino-g*, etc.
" Place case labels 0 characters from the indent of the switch().
setlocal cinoptions+=:0
" In the header public/private/protected 0 characters from the indent.
setlocal cinoptions+=g0
" Indent inside C++ namespace N characters extra compared to a normal block.
setlocal cinoptions+=N-s
" For Java anonymous classes, but works for C++'s lambdas as well.
setlocal cinoptions+=j1
