declare-option str go_impl_type_name

define-command -override go-impl -params 1.. %{
	evaluate-commands -draft %{
		select-prev-go-type
		set-option global go_impl_type_name %val{selection}
	}
	evaluate-commands %sh{
        reciever=$(echo "${kak_opt_go_impl_type_name}" | cut -b 1 |
        	tr '[:upper:]' '[:lower:]')
        printf "execute-keys \"%s\"\n" "!impl '$reciever *${kak_opt_go_impl_type_name}' '$1'<ret>"
	}
}

define-command -override select-prev-go-type %[
	execute-keys '<a-/>type\s(\w+)\sstruct\s?\{<ret>s<c-r>1<ret>'
]
