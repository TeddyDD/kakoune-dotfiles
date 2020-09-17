#  alexherbo2/evaluate-selections.kak
define-command evaluate-selections -params .. -docstring 'Evaluate selections' %{
    evaluate-commands -itersel %{
        evaluate-commands %val{selection}
    }
}
