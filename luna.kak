#colorscheme gotham
colorscheme selenized-light
# set-option global termcmd "st -e sh -c"

###########################
# LANGUAGE SERVER SUPPORT #
###########################

eval %sh{kak-lsp --kakoune -s kak_lsp_global}
hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
    lsp-enable-window
}

# evaluate-commands %sh{ cgexec -g 'memory:lsp' kak-lsp --kakoune -s kaklspglobal}
# set global lsp_hover_anchor true
#nop %sh{ (kak-lsp -s kaklspglobal -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

