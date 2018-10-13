# Mint 0.3 for Kakoune
# --------------------
# Autor: TeddyDD

# Detection
# ---------

hook global BufCreate .*[.]mint %{
    set-option buffer filetype mint

    # indentation is strictly 2 spaces in Mint
    set-option buffer indentwidth 2
    set-option buffer tabstop 2
}

# Highlighting
# ------------


add-highlighter shared/mint regions
add-highlighter shared/mint/code default-region group
add-highlighter shared/mint/double_string region '"'  (?<!\\)(\\\\)*" fill string
add-highlighter shared/mint/single_string region "'"  (?<!\\)(\\\\)*' fill string
add-highlighter shared/mint/comment       region /\*  \*/             fill comment

# styles
add-highlighter shared/mint/css  region  'style \w+' \}  regions
add-highlighter shared/mint/css/ default-region regex '(style)\s([\w]+)' 1:keyword 2:type
add-highlighter shared/mint/css/inner region \{\K (?:\}) ref css

# html
add-highlighter shared/mint/html region -recurse (?<![\w<])<[a-zA-Z][\w:.-]* (?<![\w<])<[a-zA-Z][\w:.-]*(?!\hextends)(?=[\s/>])(?!>\()) (</.*?>|/>) regions

add-highlighter shared/mint/html/tag  region -recurse <  <(?=[/a-zA-Z]) (?<!=)> regions
add-highlighter shared/mint/html/expr region -recurse \{ \{             \}      ref mint

add-highlighter shared/mint/html/tag/base default-region group
add-highlighter shared/mint/html/tag/double_string region =\K" (?<!\\)(\\\\)*" fill string
add-highlighter shared/mint/html/tag/single_string region =\K' (?<!\\)(\\\\)*' fill string
add-highlighter shared/mint/html/tag/expr region -recurse \{ \{   \}           group

add-highlighter shared/mint/html/tag/base/ regex (\w+) 1:attribute
add-highlighter shared/mint/html/tag/base/ regex </?([\w-$]+) 1:keyword
add-highlighter shared/mint/html/tag/base/ regex (</?|/?>) 0:meta

add-highlighter shared/mint/html/tag/expr/ ref mint

add-highlighter shared/mint/code/ regex ":{1}\h([\w\.]+)" 1:type
add-highlighter shared/mint/code/ regex "\d+" 0:value
add-highlighter shared/mint/code/ regex "(\w+)\(" 1:function

# keywords highlighting defined in completion section

# FIXME
add-highlighter shared/mint/javascript    region "`"  (?<!\\)(\\\\)*`         ref javascript

# Highlighting / Completion
# -------------------------

evaluate-commands %sh{
    typedefs="component|store|style|record|enum|module|provider|routes"
    keywords="where|if|else|case|try|sequence|parallel|catch|finally|then|next|connect|exposing|void|using|decode|encode|as|with"
    properties="fun|property|get|state"
    builtins="Promise|Result|Void|Never|Maybe|true|false"
    operators="[=|]>|\||::"

    printf "%s\n" "add-highlighter \"shared/mint/code/\" regex \"(?:^|\h)\b($typedefs|$keywords|$properties)\b(\h[\w\.]+)?\" 1:keyword 2:type"
    printf "%s\n" "add-highlighter \"shared/mint/code/\" regex \"\b($builtins)\b\" 1:builtin"
    printf "%s\n" "add-highlighter \"shared/mint/code/\" regex \"($operators)\" 1:operator"

    printf "%s\n" "hook global WinSetOption 'filetype=mint' %{ set-option window static_words $(echo $typedefs $keywords $properties  | tr '|' ' ')  }"

}

# Commands
# --------

define-command -hidden mint-filter-around-selections %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden mint-indent-on-new-line %<
    evaluate-commands -draft -itersel %<
        # match indentation with opening brace block
        try %! execute-keys -draft '2h<a-k>\}<ret>Zm;<a-x>_<a-z>a<a-&>' !
        # preserve previous line indent
        try %{ execute-keys -draft \; K <a-&> }
        # filter previous line
        try %{ execute-keys -draft k : mint-filter-around-selections <ret> }
        # indent after lines beginning / ending with opener token
        try %_ execute-keys -draft k <a-x> <a-k> ^\h*[[{]|[[{]$ <ret> j <a-gt> _
    >
>

define-command mint-generate-procfile -docstring 'Generate procfile in current directory' %{
	evaluate-commands %sh{
		if [ -f "./mint.json" ] && [ ! -e "./Procfile" ]; then
			touch Procfile
			echo "web: mint start" > Procfile
			echo "doc: mint docs"  >> Procfile
			echo "echo 'Created'"
		fi
	}
}

hook global WinSetOption "filetype=mint" %{
    hook window ModeChange insert:.* -group mint-hooks  mint-filter-around-selections
    hook window InsertChar \n -group mint-indent mint-indent-on-new-line
}

# Initialization
# --------------

hook global -group "mint-highlight" WinSetOption "filetype=mint" %{
    add-highlighter window/mint ref mint
}

hook global -group "mint-highlight" WinSetOption "filetype=(?!mint)" %{
    remove-highlighter window/mint
}
