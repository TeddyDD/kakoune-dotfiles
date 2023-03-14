define-command -override -docstring 'make golang comment' go-cmt %{
    evaluate-commands -save-regs 'a' %{
        execute-keys '<a-l>;<a-/>^(?:type|func)(?:\s\(.+\))?\s(\w+)<ret>'
        set-register a %reg{1} # see Kakoune issue #1720
        execute-keys O//<space><c-r>a<space>
    }
}
