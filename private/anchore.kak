define-command -override anchore-csv-to-html -docstring 'convert anchore csv to confuence table' %{
    evaluate-commands %{
        execute-keys gg3X<a-d>
        execute-keys '%|pandoc -f csv -t gfm<ret>gg'
        execute-keys '/Package Type<ret>'
        table-select-column
        execute-keys <a-d>
        execute-keys /Path<ret>
        table-select-column
        execute-keys '<a-d>ggA Comment |<esc>'
        table-align
        execute-keys '%|pandoc -f gfm -t html'
    }
}
