define-command git-log-line -docstring 'show git log for selected lines' %{
    try %{ delete-buffer! *git-log-line* }
    evaluate-commands %sh{
        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-git-log-line.XXXXXXXX)/fifo
        mkfifo "${output}"
        (
            set -eu
            trap "rm -rf ${output%/fifo}" EXIT
            cd "$(dirname "$kak_buffile")"
            root="$(git rev-parse --show-toplevel)"
            cd "$root"
            git log -L"$(echo $kak_selection_desc | sed -E 's/[.][0-9]+//g')":"$kak_buffile" >"${output}"
        ) >/dev/null 2>&1 </dev/null &
        echo edit -fifo "${output}" '*git-log-line*'
        echo set buffer filetype git-log
    }
}
