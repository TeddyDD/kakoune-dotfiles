declare-option -hidden str outline_current

declare-option -docstring "outline definitions: JSON object where key is Kakoune filetype and value is regexp for grep -En" \
str outline_regexp %{
    {
      "markdown": "^#",
      "go": "func|struct|type",
      "kak": "^declare|define|set|map"
    }
}

define-command -docstring "Create interactive outline of this file for quick jumping" outline %{
    try %{
	evaluate-commands %{ %sh{
		file="$kak_buffile"
		type=$kak_opt_filetype
		cmd="grep -En $(echo $kak_opt_outline_regexp | jq .$type) $file"
		echo "edit *outline*"
		echo "execute-keys %{ !$cmd<ret>gg }"
		echo "execute-keys -draft %{ %s:<ret>a<space><esc>& }"
		echo "set-option buffer outline_current  $file"
	}}} catch %{
		delete-buffer! *outline*
		echo -markup "{error} failed to create outline"
	}
	add-highlighter buffer regex '^\d+' 0:bold
	map buffer normal <ret> :outline-goto<ret>
}

define-command -hidden outline-goto %{
	evaluate-commands  %{
		execute-keys '<a-h>;t:'
    	edit %sh{ echo "$kak_opt_outline_current $kak_selection" }
		delete-buffer! *outline*
    }
}

