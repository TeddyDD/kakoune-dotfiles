####################
# UTILITY COMMANDS #
####################

define-command debug-hooks %{
    hook -group 'debug-hooks' global ModeChange .* %{ echo -debug %val{hook_param} }
}

# Toggle highlighter
define-command toggle-highlighter -params .. -docstring 'toggle-highlighter <argument>…: toggle an highlighter' %{
    try %{
        add-highlighter window/%arg{@} %arg{@}
        echo -markup {green} %arg{@}
    } catch %{
        remove-highlighter window/%arg{@}
        echo -markup {red} %arg{@}
    }
}

define-command lint-on-write -docstring 'Activate linting on buffer write' %{
    lint
    hook buffer -group lint BufWritePost .* %{ lint }
}

define-command clean-up-whitespaces %{
    try %{
        execute-keys -draft '%<a-s><a-K>^$<ret>s\h+$<ret>d'
    } catch %{ echo -markup "{Information} Already OK" }
}

define-command to-ascii -docstring 'Convert selection to ASCII' %{
  execute-keys '|iconv -f utf8 -t ascii//TRANSLIT<ret>'
}

define-command -params 1 underline %{
    evaluate-commands -draft %{
		execute-keys "xypx_r%arg{1}"
    }
}
alias global u underline

define-command -params 1 frame %{
    evaluate-commands -draft %{
		execute-keys "x_i%arg{1}<space><esc>A<space>%arg{1}<esc>"
		underline %arg{1}
		execute-keys jxykP
    }
}

define-command show-color -docstring 'show main selection color in status bar' %{
  evaluate-commands %sh{
    awk_script='{
      if ((x=index($1,"#")) > 0)
        $1 = substr($1, x+1)
      if (length($1) == 8)
        $1 = substr($1, 1, 6)
      if (length($1) == 4)
        $1 = substr($1, 1, 3)
      if (length($1) == 3) {
        r = substr($1, 1, 1)
        g = substr($1, 2, 1)
        b = substr($1, 3, 1)
        $1 = r r g g b b
      }
      print "evaluate-commands -client " client " echo -markup {rgb:" $1 "} ██████"
    }'
    printf %s\\n "$kak_selection" | awk -v client="$kak_client" "$awk_script" | kak -p "$kak_session"
  }
}

define-command show-color-hook -docstring 'enable color preview in current buffer' %{
    hook -group 'show-color' buffer NormalIdle .* %{
        try %{
            execute-keys -draft '<a-i>w: show-color<ret>'
        }
    }
}

define-command cd-to-buffer-dir \
-docstring 'cd to current buffers directory' %{
    evaluate-commands %sh{
        printf "change-directory '%s'\n" "$(dirname "$kak_buffile")"
    }
}


define-command date -docstring 'insert ISO-8601 date at point' %{
    execute-keys '!date --iso-8601<ret>i<backspace>'
}


define-command source-dir -params 1 \
-docstring 'source <DIR>
Loads all kak files from DIR. Not recursive.' \
%{
    evaluate-commands %sh{
        for f in "$@"/*.kak; do
            echo "source ${f%/}"
        done
    }
}

define-command for-each-line \
-docstring "for-each-line <command> <path to file>: run command with the value of each line in the file" \
-params 2 \
%{
    evaluate-commands %sh{
        while read -r f
        do
            printf "%s '%s'\n" "$1" "$f"
        done <"$2"
    }
}

define-command spawn \
-shell-completion \
-params 1.. \
-docstring 'Spawn async shell process' %{
    nop %sh{
        "$*" </dev/null >/dev/null 2>&1 &
    }
}

define-command kakrc -docstring 'edit kakrc' %{
    edit "%val{config}/kakrc"
}

define-command plugins -docstring 'edit plugins' %{
    edit "%val{config}/plugins.kak"
}

declare-option -hidden str cheat_filetype
define-command -params 1.. cheat -docstring "cheat QUERY
cheat.sh lookup" \
%{
    set-option global cheat_filetype %opt{filetype}
    try %{ delete-buffer! *cheat* }
    edit -scratch *cheat*
    execute-keys "!curl -Ss cheat.sh/%opt{cheat_filetype}/%sh{echo ""$@"" | tr ' ' '+'}<ret>"
    ansi-render
}

define-command mdfence -docstring 'wrap selection in fenced code block' %{
    execute-keys 'Zo```<esc>zO```<esc>z'
}

define-command keep-and -docstring '<a-k> but with &&' -params 1.. %{
    try %{
        execute-keys %sh{
            for regexp in "$@"
            do
                printf '<a-k>%s<ret>' "$regexp"
            done
        }
    }
}
