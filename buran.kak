colorscheme 'selenized-white'

evaluate-commands %sh{kak-lsp --kakoune -s kaklspglobal}
hook global WinSetOption filetype=(python|go) %{
    lsp-enable-window
}

map global lsp R ': lsp-rename-prompt<ret>'
set-option global ui_options "ncurses_assistant=none"
