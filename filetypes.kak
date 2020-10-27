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
    set-face window Reference default,rgba:368aeb26
    set-option window lsp_auto_highlight_references true
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
}

define-command go-hide-ierr %{
    add-highlighter window/ regex 'if err != nil .*?\{.*?\}' 0:comment
}

declare-user-mode gomode
map global gomode j :go-jump<ret> -docstring 'jump to definition'
map global gomode d :go-doc-info<ret> -docstring 'documentation'
map global gomode f :format<ret> -docstring 'format'
map global gomode h :lsp-hover<ret> -docstring 'hover'
map global gomode o %{: grep HACK|TODO|FIXME|XXX|NOTE|^func|^var|^package|^const|^goto|^struct|^type %val{bufname} -H<ret>} -docstring "Show outline"

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
    hook window BufWritePost .* %{
        cfdg-render
    }
    map window normal "'" :enter-user-mode<space>cfdgmode<ret>
}

declare-user-mode cfdgmode
map global cfdgmode r :cfdg-render<ret> -docstring 'render'

# JSON
hook global WinSetOption filetype=json %{
    set buffer formatcmd 'jq .'
}


# Shell
hook global WinSetOption filetype=sh %{
    set-option window lintcmd "shellcheck -x -f gcc"
    lint
    lint-on-write
    set-option window formatcmd "shfmt -s -knl"
}

hook global BufOpenFile '.*/colors/.*[.]kak' %{
    show-color-hook
}

hook global BufOpenFile '.*\.env.*' %{
    set-option buffer filetype "ini"
}
