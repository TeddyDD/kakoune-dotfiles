define-command -override ts-to-date %{
    execute-keys -itersel -save-regs '"t' %{"td!date -Iseconds -d @$kak_reg_t<ret>}
}
