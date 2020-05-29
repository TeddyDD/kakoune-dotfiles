define-command -hidden go-interfaces-goto %{
    execute-keys x
    evaluate-commands %sh{
        sel="$kak_selection"
        file="${sel%%:*}"
        new_sel="${sel#*:}"
        line="${new_sel%%:*}"
        cols="${new_sel#*:}"
        echo edit "$file"
        echo select "$line.$(echo $cols | cut -f 1 -d '-'),$line.$(echo $cols | cut -f 2 -d '-')"
    }
}

define-command -override go-interfaces %{
    try %{ delete-buffer! *go-interfaces* }
    evaluate-commands %sh{
        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-interfaces.XXXXXXXX)/fifo
        mkfifo "${output}"
        (
            trap "rm -rf ${output%/fifo}" EXIT
            gopls implementation "${kak_buffile}:#${kak_cursor_byte_offset}" >${output}
        ) >/dev/null 2>&1 </dev/null &
        echo edit -fifo "${output}" '*go-interfaces*'
    }
    map buffer normal <ret> ': go-interfaces-goto<ret>'
}
