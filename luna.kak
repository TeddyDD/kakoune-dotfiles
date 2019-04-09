#colorscheme gotham
colorscheme selenized-light
set global termcmd "st -e sh -c"

###########################
# LANGUAGE SERVER SUPPORT #
###########################

evaluate-commands %sh{kak-lsp --kakoune -s kaklspglobal}
lsp-enable
set global lsp_hover_anchor true
#nop %sh{ (kak-lsp -s kaklspglobal -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

