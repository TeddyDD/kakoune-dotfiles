#############################
# Global settings and hooks #
#############################

set-option global startup_info_version 20200116
set-option global grepcmd "rg -niL --column"
set-option global scrolloff '2,3'
set-option global tabstop 4

set-option -add global matching_pairs „
set-option -add global matching_pairs ”

set-option global disabled_hooks '.*-trim-indent'

# Editorconfig

hook global BufOpenFile .* editorconfig-load
hook global BufNewFile .* editorconfig-load

# This hook is executed when Kakoune starts
hook global KakBegin .* %{
    add-highlighter global/linenumbers number-lines -hlcursor -relative
    add-highlighter global/matching_char show-matching
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

# completion using tab

hook global InsertCompletionShow .* %{ map window insert <tab> <c-n> }
hook global InsertCompletionShow .* %{ map window insert <s-tab> <c-p> }
hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n> }
hook global InsertCompletionHide .* %{ unmap window insert <s-tab> <c-p> }

# Kakoune clipboard to system clipboard
hook global NormalKey y|d|c %{
    nop %sh{
        printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
    }
}

define-command sync-clip %{
    evaluate-commands %sh{
        xclip -o -r -selection clipboard > /tmp/kak-clip
        echo 'set-register dquote "%file{/tmp/kak-clip}"'
    }
}

map global normal Y ' :sync-clip<ret>'
