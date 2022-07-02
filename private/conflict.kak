# https://discuss.kakoune.com/t/quick-way-resolve-git-conflict-when-merging/1519/4
map global object m %{c^[<lt>=]{4\,}[^\n]*\n,^[<gt>=]{4\,}[^\n]*\n<ret>} -docstring 'conflict markers'
define-command conflict-use-1 %{
	evaluate-commands -draft %{
		execute-keys <a-h>h/^<lt>{4}<ret><a-x>d
		execute-keys h/^={4}<ret>j
		execute-keys -with-maps <a-a>m
		execute-keys d
	}
} -docstring "resolve a conflict by using the first version"
define-command conflict-use-2 %{
	evaluate-commands -draft %{
		execute-keys j
		execute-keys -with-maps <a-a>m
		execute-keys dh/^>{4}<ret><a-x>d
	}
} -docstring "resolve a conflict by using the second version"
