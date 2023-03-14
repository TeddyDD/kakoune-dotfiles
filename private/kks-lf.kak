declare-option -docstring "Choose where to display kks_lf panel.
    Possible values: left, right
    Default value: left
When kks_lf_split is set to 'horizontal', 'left' and 'right' will make split above or below current pane respectively." \
str kks_lf_side "left"

declare-option -docstring "The size of kks_lf pane. Can be either a number of columns or size in percentage." \
str kks_lf_size '36'

define-command kks-lf %{
	nop %sh{
    	kks_lf_cmd="kks-lf"
        export EDITOR="kks edit"
        export KKS_SESSION="$kak_session"
        export KKS_CLIENT="$kak_client"
        if [ -n "$TMUX" ]
        then
            [ "${kak_opt_kks_lf_split}" = "vertical" ] && split="-v" || split="-h"
            [ "${kak_opt_kks_lf_side}" = "left" ] && side="-b" || side=
            [ -n "${kak_opt_kks_lf_size%%*%}" ] && measure="-l" || measure="-p"
            tmux split-window -f ${split} ${side} ${measure} ${kak_opt_kks_lf_size%%%*} env EDITOR="kks edit" KKS_SESSION="$kak_session" KKS_CLIENT="$kak_client" ${kks_lf_cmd}
        elif [ -n "${kak_opt_termcmd}" ]; then
            ( ${kak_opt_termcmd} "sh -c '${kks_lf_cmd}'" ) > /dev/null 2>&1 < /dev/null &
        fi
	}
}
