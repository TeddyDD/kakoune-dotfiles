colorscheme selenized-black


eval %sh{kak-lsp --kakoune -s kak_lsp_global}
hook global WinSetOption filetype=(rust|python|go|javascript|typescript) %{
    lsp-enable-window
}
