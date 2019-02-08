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

########################
# TEXT EDITION HELPERS #
########################

define-command snakecase %{
    execute-keys '<a-:><a-;>s-|[a-z][A-Z]<ret>\;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`'
}

define-command -params 1 underline %{
    %sh{ echo "execute-keys -draft xy<a-h><a-l>PS.<ret>c$1<esc><space>h;"
}}
alias global u underline

define-command -params 1 frame %{
    evaluate-commands %sh{
    	echo "execute-keys -draft -itersel xyp<a-h><a-l>r$1A$1$1$1$1<esc>xyjp<a-h>i$1<space><esc><a-l>A<space>$1<esc>"
	}
}

#################
# PREVIEW COLOR #
#################

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

#####################
# CD TO BUFFILE DIR #
#####################

define-command cd-to-buffer-dir -docstring 'cd to current buffers directory' %{
	evaluate-commands %sh{
		printf "change-directory '%s'\n" "$(dirname $kak_buffile)"
	}
}


########
# DATE #
########

define-command date -docstring 'insert ISO-8601 date at point' %{
	execute-keys '!date --iso-8601<ret>'
}

