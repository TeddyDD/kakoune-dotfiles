colorscheme desertex 
set global termcmd 'st sh -c'

#lsp

decl str lsp_servers %{
    go:go-langserver -gocodecompletion
    rust:rustup run nightly rls
}

def lsp-start %{
    %sh{
        ( python /home/teddy/.config/kak/libkak/lspc.py $kak_session
        ) > /dev/null 2>&1 < /dev/null &
    }
}


