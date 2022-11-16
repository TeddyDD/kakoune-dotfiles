################
# KEY MAPPINGS #
################

declare-user-mode spell
map global spell p ': spell pl<ret>' -docstring 'PL'
map global spell e ': spell en<ret>' -docstring 'ENG'
map global spell f ': spell-next<ret>_: enter-user-mode spell<ret>' -docstring 'next'
map global spell s ': spell-replace<ret><ret> : enter-user-mode spell<ret>' -docstring 'lucky fix'
map global spell a ': spell-replace<ret>' -docstring 'manual fix'
map global spell c ': spell-clear<ret>' -docstring 'clear'


map global normal '#' ': comment-line<ret>' -docstring 'comment line'
map global normal '£' ': comment-block<ret>' -docstring 'comment block'
map global normal D <a-x>d -docstring 'delete line'

map global user 'r' ': surround<ret>' -docstring 'surround'
map global user 'R' ': change-surround<ret>' -docstring 'change surround'
map global user </> /(?i) -docstring 'search case insensitive'
map global user g ':grep ''''<left>' -docstring 'RipGrep'
map global user s ': enter-user-mode spell<ret>' -docstring 'Spell mode'

map global user <a-w> ': toggle-highlighter wrap -word -indent<ret>' -docstring "toggle word wrap"
map global user <a-W> ': toggle-highlighter show-whitespaces<ret>' -docstring "toggle whitespaces"
map global user W '|fmt --width 80<ret>: echo -markup Information formated selections<ret>' -docstring "Wrap to 80 columns"
map global user <space> '<esc>:' -docstring 'Command prompt'
map global user l ': enter-user-mode lsp<ret>' -docstring "Language Server"

map global goto m '<esc>m;' -docstring 'matching char'

map global user c ': cd-to-buffer-dir<ret>' -docstring 'cd to buffer directory'

map global normal <%> '<c-s>%' # save position befor %

map global user -docstring "select inner " i <a-i>
map global user -docstring "select outer"  a <a-a>

map global normal = ': prompt math: %{exec "a%val{text}<lt>esc>|%opt{math_command}<lt>ret>"}<ret>'
