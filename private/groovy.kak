hook global BufCreate "(.+\.(groovy|gvy|gy|gsh))|.+[Jj]enkinsfile.*" %{
	set-option buffer filetype groovy
}

hook global WinSetOption filetype=groovy %{
	require-module groovy
}

hook -group groovy-highlight global WinSetOption filetype=groovy %{
    add-highlighter window/groovy ref groovy
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/groovy }
}

provide-module groovy %§

add-highlighter shared/groovy regions

add-highlighter shared/groovy/code default-region group
add-highlighter shared/groovy/double_string region '"'   (?<!\\)(\\\\)*"  fill string
add-highlighter shared/groovy/single_string region "'"   (?<!\\)(\\\\)*'  fill string
add-highlighter shared/groovy/comment1 region '/\*[^*]?' '\*/' fill comment
add-highlighter shared/groovy/comment2 region '//[^/]?' $ fill comment
add-highlighter shared/groovy/shellbang region '#!.+' $ fill comment
# add-highlighter shared/groovy/code/identifiers regex '\b[$_]?[a-zA-Z0-9_]+\b' 0:variable

evaluate-commands %sh{
    keywords="as|assert|break|case|catch|class|const|continue|def|default"
    keywords="${keywords}|do|else|enum|extends|finally|for|goto|if|implements|import|in"
    keywords="${keywords}|instanceof|interface|new|package|return|super|switch|this|throw"
    keywords="${keywords}|throws|trait|try|while"
    types="true|false|null"

	printf %s "
		add-highlighter shared/groovy/code/keyword regex \b(${keywords})\b 0:keyword
		add-highlighter shared/groovy/code/builtin regex \b(${types})\b 0:builtin
	"
}

§
