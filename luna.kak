#colorscheme gotham
colorscheme selenized-light
set global termcmd "kitty -e sh -c"

###########################
# LANGUAGE SERVER SUPPORT #
###########################

evaluate-commands %sh{kak-lsp --kakoune -s kaklspglobal}
#nop %sh{ (kak-lsp -s kaklspglobal -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

##########################
# MASTER THESIS SETTINGS #
##########################

hook global BufCreate .+/magisterka/.+.md %{
	mark-pattern set TODO
	colorscheme nofrils-acme
	map buffer user 'W' '<a-i>p|fmt --width 80<ret>'
}

