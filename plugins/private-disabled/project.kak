declare-option -docstring "Current project's root path" str project_current
declare-option -docstring "File to keep list of all projects" str project_list_file "/home/teddy/.cache/kak_projects"

declare-option -docstring "List of files/directories that will determine project's root" \
               str-list project_detect ".git" 

define-command project_in %{
	evaluate-commands %{ %sh{
		if [ -z "$kak_opt_project_current" ]; then
    		for t in "$(echo $kak_opt_project_current | tr ':' ' ')"; do
    			f=$(dirname "$kak_buffile")/"$t"
    			if [ -e "$f" ]; then
    				echo "project_open %{$f}"
    				echo "echo In project: $f"
    				break
    			fi
    		done
		fi
	}}
}

define-command project_select -docstring 'Select one of your saved projects' \
	-params 1 \
	-shell-candidates %{ cat "$kak_opt_project_list_file" } %{
    evaluate-commands %{ project_open %arg{1} }
	execute-keys %{ :project_file<space> }
}

define-command project_add -docstring 'Add current project to project list' %{
	evaluate-commands %{ %sh{
		[ ! -z "$kak_opt_project_current" ] || echo "fail 'not in project'"
		echo "$kak_opt_project_current" >> "$kak_opt_project_list_file"
		cat "$kak_opt_project_list_file" | sort | uniq > "$kak_opt_project_list_file.new"
		cp "$kak_opt_project_list_file.new" "$kak_opt_project_list_file"
		rm "$kak_opt_project_list_file.new"
	}}
}

define-command project_open -docstring 'Set current project from saved projecs' \
	-shell-candidates %{ cat "$kak_opt_project_list_file" } \
	-params 1 \
	%{ evaluate-commands %{ set-option buffer project_current %arg{1} } }

define-command project_file -docstring 'Edit file in current project' \
	-shell-candidates %{ cd "$kak_opt_project_current";  find . -not -path '*/\.*' | cut -c 3- }    \
	-params 1 %{
    edit %arg{1}
}

