# ▀▛▘    ▌  ▌   ▛▀▖▛▀▖
#  ▌▞▀▖▞▀▌▞▀▌▌ ▌▌ ▌▌ ▌
#  ▌▛▀ ▌ ▌▌ ▌▚▄▌▌ ▌▌ ▌
#  ▘▝▀▘▝▀▘▝▀▘▗▄▘▀▀ ▀▀

try %{
    evaluate-commands %sh{ kks init }
    define-command kks-term %{
        kks-connect terminal
    }
    define-command kks-term-down %{
        kks-connect tmux-terminal-vertical
    }
    alias global '>' kks-term
    alias global 'v' kks-term-down
}

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
source "%val{config}/hosts.kak"
try %{
    require-module %sh{ echo "host-$(hostname)" }
}
