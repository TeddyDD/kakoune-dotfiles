# colorscheme desertex
colorscheme gruvbox

hook -once global ModuleLoad "fzf" %{
    set-option global fzf_highlight_cmd 'chroma -f terminal16m -s native {}'
}

# LSP
evaluate-commands %sh{kak-lsp -s kaklspglobal --kakoune}
nop %sh{ (kak-lsp -s kaklspglobal -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
    lsp-enable-window
}
