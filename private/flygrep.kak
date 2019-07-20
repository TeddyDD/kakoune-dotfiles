# https://discuss.kakoune.com/t/flygrep-like-grepping-in-kakoune/662

define-command -override -docstring "flygrep: run grep on every key" \
flygrep %{
    edit -scratch *grep*
    prompt "flygrep: " -on-change %{
        flygrep-call-grep %val{text}
    } nop
}

define-command -override flygrep-call-grep -params 1 %{ evaluate-commands %sh{
    length=$(printf "%s" "$1" | wc -m)
    [ -z "${1##*&*}" ] && text=$(printf "%s\n" "$1" | sed "s/&/&&/g") || text="$1"
    if [ ${length:-0} -gt 2 ]; then
        printf "%s\n" "info"
        printf "%s\n" "evaluate-commands %&grep '$text'&"
    else
        printf "%s\n" "info -title flygrep %{$((3-${length:-0})) more chars}"
    fi
}}
