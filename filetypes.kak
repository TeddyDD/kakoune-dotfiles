######################
# FILE TYPE CONFIGS  #
######################

# Fennel
hook global BufCreate .*\.fnl %{
    set-option buffer filetype lisp
}

hook global BufCreate .*\.janet %{
    set-option buffer filetype lisp
}

# TIC-80 games written in fennel
hook global BufCreate .*/TIC-80/fennel/.*\.lua %{
    set-option buffer filetype lisp
    set-option buffer -add extra_word_chars -
    lsp-diagnostic-lines-disable
}

# Markdown
hook global WinSetOption filetype=markdown %{
    set-option window lintcmd "%val{config}/bin/mdlint"
}

hook global WinSetOption filetype=python %{
    expandtab
}

# Go
hook global WinSetOption filetype=go %{
    #set buffer lintcmd '(gometalinter | grep -v "::\w") <'
    set buffer lintcmd 'revive'
    set buffer formatcmd 'goimports'
    unmap buffer normal "'"
    map buffer normal "'" :enter-user-mode<space>gomode<ret>
    hook buffer BufWritePre .* %{
        lsp-formatting
		ctags-update-tags
    }
    set-face window Reference blue+u
    hook window NormalIdle .* %{
		lsp-highlight-references
    }
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
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
map global gomode h :lsp-hover<ret> -docstring 'hover'

# Justfile
hook global BufCreate .*Justfile %{
    set buffer tabstop 4
    set buffer indentwidth 4
}

# Moonscript
hook global WinSetOption filetype=moon %{
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Crystal
hook global WinSetOption filetype=crystal %{
    set buffer tabstop 2
    set buffer indentwidth 2
}

# CFDG
hook global WinSetOption filetype=cfdg %{
    hook buffer BufWritePost .* %{
        cfdg-render
    }
    map buffer normal "'" :enter-user-mode<space>cfdgmode<ret>
}

declare-user-mode cfdgmode
map global cfdgmode r :cfdg-render<ret> -docstring 'render'

# JSON
hook global WinSetOption filetype=json %{
    set buffer formatcmd 'jq .'
}

# Git commit
hook -group git-commit-highlight global WinSetOption filetype=git-(commit|rebase) %{
    add-highlighter window/git-commit-highlight regex "^\h*[^#\s][^\n]{71}([^\n]+)" 1:yellow
}

# Shell
hook global WinSetOption filetype=sh %{
    set-option buffer lintcmd "shellcheck -f gcc"
}

hook global BufOpenFile '.*/colors/.*[.]kak' %{
    show-color-hook
}

hook global BufOpenFile '.*\.env.*' %{
    set-option buffer filetype "ini"
}
