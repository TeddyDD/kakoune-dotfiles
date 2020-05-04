define-command luadef -params 2 %{
    evaluate-commands %sh{
        tmp=$(mktemp)
        echo "$2" > "$tmp"
        vars=$(grep -o 'kak_\w*' $tmp | uniq)
        echo "
            define-command -override $1 %{
                evaluate-commands %sh{
                    # $vars
                    lua $tmp
                }
            }
            hook global KakEnd .* %{ nop %sh{ rm $tmp } }
        "
    }
}
