define-command -params 2 subvert %{
    execute-keys "|ruplacer --subvert %arg{1} %arg{2} -- -<ret>"
}
