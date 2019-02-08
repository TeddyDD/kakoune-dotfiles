colorscheme selenized-light 
set global termcmd 'kitty -e sh -c'

evaluate-commands %sh{kak-lsp --kakoune -s kaklspglobal}
lsp-enable
set global lsp_hover_anchor true
