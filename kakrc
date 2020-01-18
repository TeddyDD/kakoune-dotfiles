#                                                   
#  mmmmmmm            #      #         mmmm   mmmm  
#     #     mmm    mmm#   mmm#  m   m  #   "m #   "m
#     #    #"  #  #" "#  #" "#  "m m"  #    # #    #
#     #    #""""  #   #  #   #   #m#   #    # #    #
#     #    "#mm"  "#m##  "#m##   "#    #mmm"  #mmm" 
#                                m"                 
#                               ""                  
#   Kakoune config

# load global settings
source "%val{config}/global.kak"

# load utils
source "%val{config}/utils.kak"

# load private / WIP plugins and scripts

source-dir "%val{config}/private"

# load plug
source "%val{config}/plugins/plug.kak/rc/plug.kak"

# load plugins configuration

source "%val{config}/plugins.kak"

# load config for filetypes / languages

source "%val{config}/filetypes.kak"

# load key maps
source "%val{config}/mappings.kak"

# host specific settings
try %{ source %sh{ echo "$kak_config/$(hostname).kak" } }

define-command -override flygrep-call-grep -params 1 %{ evaluate-commands %sh{
    length=${#1}
    [ -z "${1##*&*}" ] && text=$(printf "%s\n" "$1" | sed "s/&/&&/g") || text="$1"
    if [ ${length:-0} -gt 2 ]; then
        printf "%s\n" "info"
        printf "%s\n" "evaluate-commands %&grep '$text'&"
    else
        printf "%s\n" "info -title flygrep %{$((3-${length:-0})) more chars}"
    fi
}}

declare-option str bufdir ''
hook global BufNewFile .* %{ set-option buffer bufdir %sh{ echo ${kak_buffile%/*} } }
hook global BufOpenFile .* %{ set-option buffer bufdir %sh{ echo ${kak_buffile%/*} } }

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

luadef test-hello %{
    print("info 'hello from lua! session:" .. os.getenv'kak_session' .. "'")
}
