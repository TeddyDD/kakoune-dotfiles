define-command -override go-template-def %{
    evaluate-commands -save-regs a %{
        execute-keys -draft '<a-i>c\{\{,\}\}<ret>stemplate<space>".+"<ret>h<a-i>""ay'
        evaluate-commands %{
            grep "define ""%reg{a}"""
        }
        grep-next-match
    }
}
