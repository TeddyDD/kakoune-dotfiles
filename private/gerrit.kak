define-command -hidden gerrit-goto %{
    evaluate-commands -save-regs 'a' %{
        evaluate-commands -draft %{
            execute-keys -draft  %{
                <a-i>p<a-:><a-;>x"ay
            }
        }
        execute-keys %{
            : edit<space><c-r>a<ret>
        }
    }
}

define-command gerrit-comments %{
    try %{ delete-buffer! *gerrit* }
    # edit -scratch *gerrit*
    evaluate-commands %sh{
        url="$(git config --get remote.origin.url | sed -e 's!^ssh://!!')"
        url="${url%/*}" # strip repo
        port="$(echo "$url" | awk -F : '{ print $NF }')"
        url="${url%:*}" # strip port
        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-gerrit.XXXXXXXX)/fifo
        id=$(git log | grep -o -E "Change-Id:\s(.{41})" | head -n 1 | cut -f 2 -d ' ')
        mkfifo "${output}"
        (
            trap "rm -rf ${output%/fifo}" EXIT
            ssh -p "$port" "$url" gerrit query --comments --patch-sets --format json $id |
                jq -r '.patchSets[] | select(.comments) | .comments[] | {file, line, message} | "\(.file) \(.line)\n\(.message)\n"' >${output}
        ) >/dev/null 2>&1 </dev/null &

        echo echo "$url" "$port"
        echo edit -fifo "${output}" '*gerrit*'
    }
    add-highlighter buffer/ regex '^[^\s]+\s(\d+)$' 0:blue 1:green
    map buffer normal <ret> ': gerrit-goto<ret>'
}
