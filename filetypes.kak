######################
# FILE TYPE CONFIGS  #
######################

require-module 'filetypes-sugar'

for-extension "(fnl|janet)" %{
    set-option buffer filetype lisp
}

# TIC-80 games written in fennel
hook global BufCreate .*/TIC-80/fennel/.*\.lua %{
    set-option buffer filetype lisp
    set-option buffer -add extra_word_chars -
    lsp-diagnostic-lines-disable
}

for-filetype "(python|yaml|lua|cucumber)" %{
    expandtab
}

# Go
hook global WinSetOption filetype=go %{
    #set buffer lintcmd '(gometalinter | grep -v "::\w") <'
    # set buffer lintcmd 'revive'
    # set buffer formatcmd 'goimports'
    unmap buffer normal "'"
    map buffer normal "'" :enter-user-mode<space>gomode<ret>
    hook buffer BufWritePre .* %{
		ctags-update-tags
		lsp-formatting-sync
    }
    set-face window Reference default,rgba:368aeb26
    set-option window lsp_auto_highlight_references true
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
}

define-command go-hide-ierr %{
    add-highlighter window/ regex 'if err != nil .*?\{.*?\}' 0:comment
}

# declare-user-mode gomode
# map global gomode j :go-jump<ret> -docstring 'jump to definition'
# map global gomode d :go-doc-info<ret> -docstring 'documentation'
# map global gomode f :format<ret> -docstring 'format'
# map global gomode h :lsp-hover<ret> -docstring 'hover'
# map global gomode o %{: grep HACK|TODO|FIXME|XXX|NOTE|^func|^var|^package|^const|^goto|^struct|^type %val{bufname} -H<ret>} -docstring "Show outline"

# Crystal
for-filetype crystal %{
    set buffer tabstop 2
    set buffer indentwidth 2
}

# CFDG
for-filetype cfdg %{
    hook window BufWritePost .* %{
        cfdg-render
    }
    map window normal "'" :enter-user-mode<space>cfdgmode<ret>
}

declare-user-mode cfdgmode
map global cfdgmode r :cfdg-render<ret> -docstring 'render'

# JSON
for-filetype json %{
    set buffer formatcmd 'jq .'
}


# Shell
for-filetype sh %{
    set-option window lintcmd "shellcheck -x -f gcc"
    lint
    lint-on-write
    set-option window formatcmd "shfmt -s -knl"
}

hook global BufOpenFile '.*\.env.*' %{
    set-option buffer filetype "ini"
}
