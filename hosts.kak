# Host specific configs

provide-module host-moon %£
	colorscheme selenized-white
    source "%val{config}/moon-theme.kak"
    evaluate-commands %sh{kak-lsp --kakoune -s $kak_session}
    hook global WinSetOption filetype=(rust|python|go|javascript|typescript|perl) %{
        lsp-enable-window
    }
£

provide-module host-flyby %£

colorscheme 'selenized-white'

evaluate-commands %sh{kak-lsp --kakoune -s "$kak_session"}
hook global WinSetOption filetype=(python|go|c|typescript|dart) %{
    lsp-enable-window
}

# map global lsp R ': lsp-rename-prompt<ret>'
set-option global ui_options "terminal_assistant=none"

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
