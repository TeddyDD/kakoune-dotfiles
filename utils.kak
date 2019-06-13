####################
# UTILITY COMMANDS #
####################

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
    lint-enable
    hook buffer -group lint BufWritePost .* %{ lint }
}

define-command clean-up-whitespaces %{
    execute-keys -draft '%<a-s><a-K>^$<ret>s\h+$<ret>d'
}

define-command to-ascii %{
  execute-keys '|iconv -f utf8 -t ascii//TRANSLIT<ret>'
}

define-command -params 1 underline %{
    evaluate-commands %sh{ echo "execute-keys -draft xy<a-h><a-l>PS.<ret>c$1<esc><space>h;"
}}
alias global u underline

define-command -params 1 frame %{
    evaluate-commands %sh{
    	echo "execute-keys -draft -itersel xyp<a-h><a-l>r$1A$1$1$1$1<esc>xyjp<a-h>i$1<space><esc><a-l>A<space>$1<esc>"
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
		printf "change-directory '%s'\n" "$(dirname $kak_buffile)"
	}
}


define-command date -docstring 'insert ISO-8601 date at point' %{
	execute-keys '!date --iso-8601<ret>'
}

define-command source-dir -params 1 \
-docstring 'source <DIR>
Loads all kak files from DIR. Not recursive.
Do not add trailing / to DIR path' \
%{
    evaluate-commands %sh{
		for f in "$@"/*.kak; do
			echo "source $f"
		done
    }
}

define-command for-each-line \
    -docstring "for-each-line <command> <path to file>: run command with the value of each line in the file" \
    -params 2 \
    %{ evaluate-commands %sh{

    while read f; do
        printf "$1 $f\n"
    done < "$2"
}}

define-command spawn -params 1.. %{
    nop %sh{
        "$*" </dev/null >/dev/null 2>&1 &
    }
}

define-command rofi-buffers \
-docstring 'Select an open buffer using Rofi' %{
    evaluate-commands %sh{
    BUFFER=$(echo ${kak_buflist} | tr ' ' '\n' | rofi -dmenu)
    if [ -n "$BUFFER" ]; then
        echo "eval -client '$kak_client' buffer ${BUFFER}" | kak -p ${kak_session}
    fi
} }

define-command file-find -params 1 -shell-script-candidates %{ find . -type f } %{ edit %arg{1} }

define-command suspend-and-resume \
    -params 1..2 \
    -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
    %{ evaluate-commands %sh{

    # Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
    cli_cmd="$1 && fg"
    post_resume_cmd="$2"

    # automation is different platform to platform
    platform=$(uname -s)
    case $platform in
        Darwin)
            automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\\n\" '"
            kill_cmd="/bin/kill"
            break
            ;;
        Linux)
            automate_cmd="sleep 0.2; xdotool type '$cli_cmd'; xdotool key Return"
            kill_cmd="/usr/bin/kill"
            break
            ;;
    esac

    # Uses platforms automation to schedule the typing of our cli command
    nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
    # Send kakoune client to the background
    $kill_cmd -SIGTSTP $kak_client_pid

    # ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

    # Upon resume, run the kak command is specified
    if [ ! -z "$post_resume_cmd" ]; then
        echo "$post_resume_cmd"
    fi
}}


define-command lf-file-select %{
    suspend-and-resume \
        "lf -selection-path /tmp/ranger-files-%val{client_pid}" \
        "for-each-line edit /tmp/ranger-files-%val{client_pid}"
}

define-command t -docstring 'Open terminal in cwd' %{
    evaluate-commands %sh{
		echo "terminal /usr/bin/fish -iC 'cd ''$(pwd)'''"
    }
}

define-command kakrc -docstring 'edit kakrc' %{
	edit "%val{config}/kakrc"
}
