hook global BufCreate "(.+\.(groovy|gvy|gy|gsh))|.+[Jj]enkinsfile.*" %{
	set-option buffer filetype groovy
	set-option buffer comment_line '//'
	set-option buffer comment_block_begin '/*'
	set-option buffer comment_block_begin '*/'
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
add-highlighter shared/groovy/triple_quote region '"{3}'   (?<!\\)(\\\\)*"{3}  fill string
add-highlighter shared/groovy/double_string region '"'   (?<!\\)(\\\\)*"  fill string
add-highlighter shared/groovy/single_string region "'"   (?<!\\)(\\\\)*'  fill string
add-highlighter shared/groovy/comment1 region '/\*[^*]?' '\*/' fill comment
add-highlighter shared/groovy/comment2 region '//[^/]?' $ fill comment
add-highlighter shared/groovy/shellbang region '#!.+' $ fill comment
add-highlighter shared/groovy/dollar_string region "\$/" "(?<!\$)/\$"   fill string
# add-highlighter shared/groovy/code/identifiers regex '\b[$_]?[a-zA-Z0-9_]+\b' 0:variable
add-highlighter shared/groovy/code/declaration regex "(?<typ>\w+)(?:\[.*?\])?\s+(\$?\w+)\s=" typ:type
add-highlighter shared/groovy/code/numbers regex '\b[-+]?0x[A-Fa-f0-9_]+[.A-Fa-f0-9_p]*[lLiDgGIF]?|\b[-+]?[\d]+b?[.p_\dEe]*[lLiDgGIF]?' 0:value
add-highlighter shared/groovy/slashy_string region "\b/\w" "(?<!\\)\w/\b"   fill string

evaluate-commands %sh{
    keywords="as|assert|break|case|catch|class|const|continue|def|default"
    keywords="${keywords}|do|else|enum|extends|finally|for|goto|if|implements|import|in"
    keywords="${keywords}|instanceof|interface|new|package|return|super|switch|this|throw"
    keywords="${keywords}|throws|trait|try|while"
    builtins="true|false|null"
	types="byte|char|short|int|long|BigInteger|float|double|BigDecimal|boolean"

	printf %s "
		add-highlighter shared/groovy/code/keyword regex \b(${keywords})\b 0:keyword
		add-highlighter shared/groovy/code/builtin regex \b(${builtins})\b 0:builtin
		add-highlighter shared/groovy/code/types   regex \b(${types})\b    0:type
	"
}

§
