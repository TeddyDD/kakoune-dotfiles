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

###########
# PLUGINS #
###########

source "%val{config}/plugins/kakoune-plug/plug.kak"

plug "https://github.com/Delapouite/kakoune-text-objects"
plug "https://github.com/Delapouite/kakoune-auto-percent"
plug "https://github.com/Delapouite/kakoune-buffers"
plug "https://github.com/Delapouite/kakoune-i3"
plug "https://github.com/Delapouite/kakoune-mirror"
plug "https://github.com/Delapouite/kakoune-palette"
plug "https://github.com/Delapouite/kakoune-select-view"

plug "https://github.com/occivink/kakoune-find"
plug "https://github.com/occivink/kakoune-expand"

plug "https://github.com/occivink/kakoune-phantom-selection"
map global insert '<c-a>' '<esc>:phantom-sel-iterate-next<ret>a'
map global insert '<c-q>' '<esc>:phantom-sel-iterate-next<ret>c'
map global normal '<c-a>' ':phantom-sel-iterate-next<ret>'
map global normal '<c-q>' ':phantom-sel-clear<ret>'

plug "https://github.com/occivink/kakoune-sudo-write"
plug "https://github.com/occivink/kakoune-vertical-selection"

plug "https://github.com/lenormf/kakoune-extra" "hatch_terminal.kak"
alias global t hatch-terminal-x11

plug "https://github.com/lenormf/kakoune-extra" "lineindent.kak"

plug "https://github.com/alexherbo2/auto-pairs.kak" 
plug "https://github.com/alexherbo2/distraction-free.kak" 

plug "https://github.com/h-youhei/kakoune-each-line-selection"
plug "https://github.com/h-youhei/kakoune-surround"

plug "https://gitlab.com/fsub/kakoune-mark"

plug "https://gitlab.com/notramo/crystal.kak.git"

plug "https://github.com/andreyorst/fzf.kak" "*.kak"
set-option global fzf_highlighter 'chroma -f terminal16m -s solarized-light {}'
map global user f ': fzf-mode<ret>'

plug "github.com/laelath/kakoune-show-matching-insert"

##############
# MY PLUGINS #
##############

plug "https://github.com/TeddyDD/kakoune-wiki"
plug "https://github.com/TeddyDD/kakoune-lf"
plug "https://github.com/TeddyDD/kakoune-cfdg"

plug "https://github.com/TeddyDD/kakoune-edit-or-dir"
unalias global e
alias global e edit-or-dir

###########
# PRIVATE #
###########

evaluate-commands %sh{
    files=$(find $kak_config/plugins/private -path "*.kak" -type f)
    for f in $files; do
        echo "source $f"
    done
}

########
# WIKI #
########

wiki_setup "/home/teddy/Notatki/wiki"
map global user w :wiki<space> -docstring 'wiki'

define-command diary %{
	edit ~/Notatki/wiki/dziennik-public.md
	execute-keys 'geo<esc>! date "+%Y-%m-%d: %H:%M"<ret>k'
	underline -
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

define-command file-find -params 1 -shell-candidates %{ find . -type f } %{ edit %arg{1} }

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
-shell-candidates %{ gopkgs } \
go-import %{ evaluate-commands -draft -no-hooks %{ %sh{
    path_file_tmp=$(mktemp "${TMPDIR:-/tmp}"/kak-go-import-XXXXXX)
    echo "
        write ""${path_file_tmp}""

        nop %sh{
            readonly path_file_out=\$(mktemp ""${TMPDIR:-/tmp}""/kak-go-import-XXXXXX)

            if cat ""${path_file_tmp}"" | eval ""goimport -add $1"" > ""\${path_file_out}""; then
                printf '%s\\n' ""execute-keys \\%|cat<space>'\${path_file_out}'<ret>""
                printf '%s\\n' ""%sh{ rm -f '\${path_file_out}' }""
            else
                printf '%s\\n' ""
                    evaluate-commands -client '${kak_client}' echo -markup '{Error}goimport returned an error (\$?)'
                ""
                rm -f ""\${path_file_out}""
            fi

            rm -f ""${path_file_tmp}""
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


map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal <a-R> :surround<ret>
map global normal D <a-x>d -docstring 'delete line'

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

map global normal <f2> <a-i>w:mark-word<ret>
map global normal <f3> :mark-clear<ret>

map global normal <space> ,
map global user <space> <space>

map global user -docstring "select inner " i <a-i>
map global user -docstring "select outer"  o <a-a>

map global user -docstring "surround with" r :auto-pairs-surround<ret>
