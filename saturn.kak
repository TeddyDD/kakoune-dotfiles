colorscheme selenized-black

evaluate-commands %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c) %{
    lsp-enable-window
}

