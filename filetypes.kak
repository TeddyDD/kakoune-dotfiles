######################
# FILE TYPE CONFIGS  #
######################

require-module 'filetypes-sugar'

for-extension "(janet)" %{
    set-option buffer filetype lisp
}

# TIC-80 games written in fennel
hook global BufCreate .*/TIC-80/fennel/.*\.lua %{
    set-option buffer filetype fennel
    set-option buffer -add extra_word_chars -
    lsp-diagnostic-lines-disable
}

for-filetype "(python|yaml|lua|cucumber)" %{
    expandtab
}

for-filetype "(git-commit|markdown)" %{
    set-option buffer lintcmd "%val{config}/bin/lt-wrapper"
}

for-filetype "git-commit" %{
	map buffer user W '| fmt -w 72<ret>'
}

for-filetype "fish" %{
	set-option buffer formatcmd 'fish -c fish_indent'
}

# Go

for-filetype go %{
    ctags-generate
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
	map window user W '| fmt -w 80 -p //<ret>'
    set-face window Reference default,rgba:368aeb26
    set-option window lsp_auto_highlight_references true
    set-option window lintcmd 'revive'
    set-option window formatcmd 'goreturns'
    hook window BufWritePre .* %{
		lsp-formatting-sync
    }
    hook window BufWritePost .* %{
		ctags-update-tags
    }
}

# hook global WinSetOption filetype=go %{
#     #set buffer lintcmd '(gometalinter | grep -v "::\w") <'
#     # set buffer lintcmd 'revive'
#     # set buffer formatcmd 'goimports'
#     unmap buffer normal "'"
#     map buffer normal "'" :enter-user-mode<space>gomode<ret>
#     hook buffer BufWritePre .* %{
# 		ctags-update-tags
# 		lsp-formatting-sync
#     }
#     lsp-auto-hover-enable
#     lsp-auto-signature-help-enable
# }

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
    set-option buffer filetype "sh"
}
