set-option global grepcmd "rg -niL --column"
set-option global scrolloff '2,3'
set-option global tabstop 4

set-option -add global matching_pairs „
set-option -add global matching_pairs ”

###################
# DEVICE SPECIFIC #
###################

source %sh{ echo "$kak_config/$(hostname).kak" }

#########
# UTILS #
#########

source "%val{config}/utils.kak"

########
# TEST #
########

define-command suspend -params 2 %{ evaluate-commands %sh{
  nohup sh -c "sleep 0.2; xdotool type '$1'; xdotool key Return" > /dev/null 2>&1 &
  /usr/bin/kill -SIGTSTP $kak_client_pid
  echo "$2"
}}

hook global NormalKey a %{
	try %{
		execute-keys -draft	'<a-k>\n<ret>'
		execute-keys '<esc>A'
	}
}

# fuck muscle memory

map global normal <left> ' :nop<ret>'
map global normal <right> ' :nop<ret>'
map global normal <up> ' :nop<ret>'
map global normal <down> ' :nop<ret>'
###########
# PLUGINS #
###########

source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "https://github.com/Delapouite/kakoune-text-objects"
plug "https://github.com/Delapouite/kakoune-auto-percent"
plug "https://github.com/Delapouite/kakoune-buffers"
plug "https://github.com/Delapouite/kakoune-i3"
plug "https://github.com/Delapouite/kakoune-mirror"
plug "https://github.com/Delapouite/kakoune-palette"
plug "https://github.com/Delapouite/kakoune-select-view"

plug "https://github.com/occivink/kakoune-find"
plug "https://github.com/occivink/kakoune-expand"

plug "https://github.com/occivink/kakoune-phantom-selection" %{
    map global insert '<c-a>' '<esc>:phantom-sel-iterate-next<ret>'
    map global insert '<c-w>' '<esc>:phantom-sel-select-all<ret>'
    map global normal '<c-a>' ':phantom-sel-iterate-next<ret>'
    map global normal '<c-q>' ':phantom-sel-clear'
    map global normal '<c-q>' '<esc>:phantom-sel-clear<ret>'
    map global normal '<c-w>' ':phantom-sel-select-all<ret>'
}

plug "https://github.com/occivink/kakoune-sudo-write"
plug "https://github.com/occivink/kakoune-vertical-selection"

plug "https://github.com/danr/kakoune-easymotion" "commit: 40d73d"  %{
    declare-user-mode easy-motion
    map global easy-motion j ' :easy-motion-j<ret>'
    map global easy-motion k ' :easy-motion-k<ret>'
    map global easy-motion w ' :easy-motion-w<ret>'
    map global easy-motion b ' :easy-motion-b<ret>'
    map global easy-motion W ' :easy-motion-W<ret>'
    map global easy-motion B ' :easy-motion-B<ret>'
    map global easy-motion f ' :easy-motion-f<ret>'
    map global easy-motion <a-f> ' :easy-motion-alt-f<ret>'
    map global user j ' :enter-user-mode easy-motion<ret>' -docstring 'easy motion'
}

plug "https://github.com/lenormf/kakoune-extra" load %{
    hatch_terminal.kak
    lineindent.kak
} %{
    alias global t hatch-terminal-x11
}

plug "https://github.com/alexherbo2/auto-pairs.kak" 
plug "https://github.com/alexherbo2/distraction-free.kak"

plug "https://github.com/alexherbo2/select.kak"
plug "https://github.com/alexherbo2/yank-ring.kak" %{
	map global user y :yank-ring<ret> -docstring 'yank ring'
}

plug "https://github.com/h-youhei/kakoune-each-line-selection"
plug "https://github.com/h-youhei/kakoune-surround"

plug "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <f2> <a-i>w:mark-word<ret>
    map global normal <f3> :mark-clear<ret>
}

plug "https://gitlab.com/notramo/crystal.kak.git"

plug "andreyorst/smarttab.kak"
plug "https://github.com/andreyorst/fzf.kak" %{
    set-option global fzf_highlighter 'chroma -f terminal16m -s solarized-light {}'
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
}

plug "https://github.com/laelath/kakoune-show-matching-insert"

plug "https://github.com/eraserhd/kak-ansi"

plug "eraserhd/parinfer-rust" do %{
    cargo build --release
    cargo install --force
} %{
    hook -group parinfer global WinSetOption filetype=lisp %{
        parinfer -if-enabled -paren
        hook -group parinfer window NormalKey .* %{ parinfer -if-enabled -smart }
        hook -group parinfer window InsertChar .* %{ parinfer -if-enabled -smart }
        hook -group parinfer window InsertDelete .* %{ parinfer -if-enabled -smart }
    }
} 
##############
# MY PLUGINS #
##############

plug "https://github.com/TeddyDD/kakoune-wiki" %{
    wiki_setup "/home/teddy/Notatki/wiki"
    map global user w :wiki<space> -docstring 'wiki'

    define-command diary %{
    	edit ~/Notatki/wiki/dziennik-public.md
    	execute-keys 'geo<esc>! date "+%Y-%m-%d: %H:%M"<ret>k'
    	underline -
    }
}

plug "https://github.com/TeddyDD/kakoune-lf"
plug "https://github.com/TeddyDD/kakoune-cfdg"

plug "https://github.com/TeddyDD/kakoune-edit-or-dir" %{
    unalias global e
    alias global e edit-or-dir
}

###########
# PRIVATE #
###########

evaluate-commands %sh{
    files=$(find $kak_config/plugins/private -path "*.kak" -type f)
    for f in $files; do
        echo "source $f"
    done
}

############
# COMMANDS #
############

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

################
# GLOBAL HOOKS #
################

# Global file open hook
# This hook is executed every time buffer is open
hook global BufOpenFile .* %{
    modeline-parse
	editorconfig-load
}

# This hook is executed when Kakoune starts
hook global KakBegin .* %{
    add-highlighter global/linenumbers number-lines -hlcursor -relative
	add-highlighter global/matching_char show-matching
	add-highlighter global/matching_prev_char ranges show_matching_insert

    # search word
    add-highlighter global/ dynregex '%reg{/}' 0:+u
}

# Make directory if not exisit
hook global BufWritePre .* %{ nop %sh{ dir=$(dirname $kak_buffile)
  [ -d $dir ] || mkdir --parents $dir
}}

# jj to exit inset mode
hook -group jj global InsertChar j %{ try %{
    execute-keys -draft hH <a-k>jj<ret> d
    execute-keys <esc>
}}

########################
# completion using tab #
########################

hook global InsertCompletionShow .* %{ map window insert <tab> <c-n> }
hook global InsertCompletionShow .* %{ map window insert <s-tab> <c-p> }
hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n> }
hook global InsertCompletionHide .* %{ unmap window insert <s-tab> <c-p> }

###############################
# COPY SELECTION TO CLIPBOARD #
###############################

hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

######################
# FILE TYPE SPECIFIC #
######################

# Fennel
hook global BufCreate .*\.fnl %{
	set-option buffer filetype lisp
}

# TIC-80 games written in fennel
hook global BufCreate .*/TIC-80/fennel/.*\.lua %{
    set-option buffer filetype lisp
    set-option buffer -add extra_word_chars -
    lsp-diagnostic-lines-disable
}

# Markdown
# ########

hook global WinSetOption filetype=markdown %{
    set-option window lintcmd "%val{config}/bin/mdlint"
}

# Go
# ##

hook global  WinSetOption filetype=go %{
    #set buffer lintcmd '(gometalinter | grep -v "::\w") <'
    set buffer lintcmd 'revive'
    set buffer formatcmd 'goreturns'
	unmap buffer normal "'"
	map buffer normal "'" :enter-user-mode<space>gomode<ret>
	hook buffer BufWritePre .* %{
    	lsp-formatting
	}
}

# go get -u arp242.net/goimport
# go get -u github.com/uudashr/gopkgs/cmd/gopkgs
# FIXME
define-command -params 1 \
-shell-script-candidates %{ gopkgs } \
go-import %{ evaluate-commands -draft -no-hooks %{
    evaluate-commands %sh{
    path_file_tmp=$(mktemp "${TMPDIR:-/tmp}"/kak-go-import-XXXXXX)
    goimportcmd="goimport -add ${1}"
    printf %s\\n "
        write -sync \"${path_file_tmp}\"

        evaluate-commands %sh{
            readonly path_file_out=\$(mktemp \"${TMPDIR:-/tmp}\"/kak-formatter-XXXXXX)

            if cat \"${path_file_tmp}\" | eval \"${goimportcmd}\" > \"\${path_file_out}\"; then
                printf '%s\\n' \"execute-keys \\%|cat<space>'\${path_file_out}'<ret>\"
                printf '%s\\n' \"nop %sh{ rm -f '\${path_file_out}' }\"
            else
                printf '%s\\n' \"
                    evaluate-commands -client '${kak_client}' echo -markup '{Error}goimport returned an error (\$?)'
                \"
                rm -f \"\${path_file_out}\"
            fi

            rm -f \"${path_file_tmp}\"
        }
    "
}}}

declare-user-mode gomode
map global gomode i :go-import<space> -docstring 'import'
map global gomode j :go-jump<ret> -docstring 'jump to definition'
map global gomode d :go-doc-info<ret> -docstring 'documentation'
map global gomode f :format<ret> -docstring 'format'

# Justfile
# ########

hook global BufCreate .*Justfile %{
    set buffer tabstop 4
    set buffer indentwidth 4
}

# Moonscript
# ##########

hook global WinSetOption filetype=moon %{
	set buffer tabstop 2
	set buffer indentwidth 2
}

# Crystal
# #######

hook global WinSetOption filetype=crystal %{
	set buffer tabstop 2
	set buffer indentwidth 2
}

# CFDG
# ####

hook global WinSetOption filetype=cfdg %{
    hook buffer BufWritePost .* %{
		cfdg-render
	}
	map buffer normal "'" :enter-user-mode<space>cfdgmode<ret>
}

declare-user-mode cfdgmode
map global cfdgmode r :cfdg-render<ret> -docstring 'render'

# JSON
# ####

hook global WinSetOption filetype=json %{
    set buffer formatcmd 'jq .'
}

# Git commit
# ##########

hook -group git-commit-highlight global WinSetOption filetype=git-(commit|rebase) %{
    add-highlighter window/git-commit-highlight regex "^\h*[^#\s][^\n]{71}([^\n]+)" 1:yellow
}

# Shell
# #####

hook global WinSetOption filetype=sh %{
	set-option buffer lintcmd "shellcheck -f gcc"
}


hook global BufOpenFile '.*/colors/.*[.]kak' %{
    show-color-hook
}

###############
# keybindings #
###############

declare-user-mode spell
map global spell p ': spell pl<ret>' -docstring 'PL'
map global spell e ': spell en<ret>' -docstring 'ENG'
map global spell f ': spell-next<ret>_: enter-user-mode spell<ret>' -docstring 'next'
map global spell s ': spell-replace<ret><ret> : enter-user-mode spell<ret>' -docstring 'lucky fix'
map global spell a ': spell-replace<ret>' -docstring 'manual fix'
map global spell c ': spell-clear<ret>' -docstring 'clear'


map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal <a-R> :surround<ret>
map global normal D <a-x>d -docstring 'delete line'
map global normal v V

map global user '#' :comment-block<ret> -docstring 'Comment block'
map global user </> /(?i) -docstring 'search case insensitive'
map global user e ':expand<ret>' -docstring 'Expand Selection'
map global user d ':edit ~/.config/kak/kakrc<ret>' -docstring 'edit dotfile'
map global user g ':grep ' -docstring 'RipGrep'
map global user s ': enter-user-mode spell<ret>' -docstring 'Spell mode'

map global user P '!xsel --output --clipboard<ret>' -docstring 'Paste before'
map global user p '<a-!>xsel --output --clipboard<ret>' -docstring 'Paste after'
map global user R '|xclip -o<ret>' -docstring "Replace with clipboard"

map global user <a-w> ':toggle-highlighter wrap -word<ret>' -docstring "toggle word wrap"
map global user <a-W> ':toggle-highlighter show-whitespaces<ret>' -docstring "toggle whitespaces"
map global user W '|fmt --width 80<ret>:echo -markup Information formated selections<ret>' -docstring "Wrap to 80 columns"

map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
map global buffers r ':rofi-buffers<ret>' -docstring 'Rofi buffer list'

map global goto m '<esc>m;' -docstring 'matching char'

map global user c ':cd-to-buffer-dir<ret>' -docstring 'cd to buffer directory'


map global normal <space> ,
map global user <space> <space>

map global user -docstring "select inner " i <a-i>
map global user -docstring "select outer"  o <a-a>

map global user -docstring "surround with" r :auto-pairs-surround<ret>
