# Host specific configs

provide-module host-moon %£
	colorscheme selenized-white
    eval %sh{kak-lsp --kakoune -s kak_lsp_global}
    hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
        lsp-enable-window
    }
£

provide-module host-buran %£

colorscheme 'selenized-white'

evaluate-commands %sh{kak-lsp --kakoune -s kaklspglobal}
hook global WinSetOption filetype=(python|go|sh) %{
    lsp-enable-window
}

map global lsp R ': lsp-rename-prompt<ret>'
set-option global ui_options "ncurses_assistant=none"

£

provide-module host-luna %£
colorscheme selenized-white

eval %sh{kak-lsp --kakoune -s kak_lsp_global}
hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
    lsp-enable-window
}

# evaluate-commands %sh{ cgexec -g 'memory:lsp' kak-lsp --kakoune -s kaklspglobal}
# set global lsp_hover_anchor true
#nop %sh{ (kak-lsp -s kaklspglobal -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

£


provide-module host-wilczyca %£

colorscheme selenized-black
eval %sh{kak-lsp --kakoune -s kak_lsp_global}
hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
    lsp-enable-window
}

£
