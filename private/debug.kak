declare-user-mode echo

map global echo o ':echo %opt{}<left>'        -docstring 'opt'
map global echo O ':echo -debug %opt{}<left>' -docstring 'opt debug'
map global echo r ':echo %reg{}<left>'        -docstring 'reg'
map global echo R ':echo -debug %reg{}<left>' -docstring 'reg debug'
map global echo s ':echo %sh{}<left>'         -docstring 'sh'
map global echo S ':echo -debug %sh{}<left>'  -docstring 'sh debug'
map global echo v ':echo %val{}<left>'        -docstring 'val'
map global echo V ':echo -debug %val{}<left>' -docstring 'val debug'

map global user D ': enter-user-mode echo<ret>' -docstring 'Debug mode'
