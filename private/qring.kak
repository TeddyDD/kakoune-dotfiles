provide-module qring %£

declare-option str-list qring_keys

define-command qring-enable %{
    hook -group qring global RawKey .* %{
        set-option -add global qring_keys "%val{hook_param}"
    }

    hook -group qring global InsertIdle .* %{
        qring-trim
    }

    hook -group qring global NormalIdle .* %{
        qring-trim
    }
}

define-command qring-disable %{
    remove-hooks global qring
}

define-command qring-show -params 0..1 %{
    qring-disable
    try %{ delete-buffer! *qring* }
    evaluate-commands -save-regs dquote %{
        edit -scratch *qring*
        set-register dquote %opt{qring_keys}
        execute-keys "<a-p>i<ret><esc><space>;ge"
        unmap buffer normal q
        unmap buffer normal Q
        map buffer normal q ': qring-cancel<ret>'
        map buffer normal Q ': qring-accept<ret>'
    }
}

define-command -hidden qring-cancel %{
    evaluate-commands %{
        delete-buffer!
        qring-enable
    }
}

define-command -hidden qring-accept %{
    evaluate-commands %
        set-register '@' %sh{ echo $kak_selections | tr -d ' ' }
        delete-buffer!
        qring-enable
    }
}

define-command -hidden qring-trim %{
    nop %sh{
        (
            eval "set -- $kak_quoted_opt_qring_keys"
            if [ $# -gt 100 ]
            then
                shift $(($# - 100))
            fi
            echo set-option global qring_keys $@ | kak -p "$kak_session"
        ) > /dev/null 2>&1 < /dev/null &
    }
}

£
