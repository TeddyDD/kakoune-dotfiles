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
map global normal <a-R> ': surround<ret>' -docstring 'surround'
map global normal D <a-x>d -docstring 'delete line'

map global user '#' ': comment-block<ret>' -docstring 'Comment block'
map global user </> /(?i) -docstring 'search case insensitive'
map global user e ': expand<ret>' -docstring 'Expand Selection'
map global user d ': edit ~/.config/kak/kakrc<ret>' -docstring 'edit dotfile'
map global user g ': grep ' -docstring 'RipGrep'
map global user s ': enter-user-mode spell<ret>' -docstring 'Spell mode'

map global user P '!xsel --output --clipboard<ret>' -docstring 'Paste before'
map global user p '<a-!>xsel --output --clipboard<ret>' -docstring 'Paste after'
map global user R '|xclip -o<ret>' -docstring "Replace with clipboard"

map global user <a-w> ': toggle-highlighter wrap -word<ret>' -docstring "toggle word wrap"
map global user <a-W> ': toggle-highlighter show-whitespaces<ret>' -docstring "toggle whitespaces"
map global user W '|fmt --width 80<ret>: echo -markup Information formated selections<ret>' -docstring "Wrap to 80 columns"


map global goto m '<esc>m;' -docstring 'matching char'

map global user c ': cd-to-buffer-dir<ret>' -docstring 'cd to buffer directory'

map global normal <space> , -docstring 'User mode'
map global user <space> <space> -docstring 'Clear selections'

map global user -docstring "select inner " i <a-i>
map global user -docstring "select outer"  a <a-a>

map global user -docstring "surround with" r ': auto-pairs-surround<ret>'
