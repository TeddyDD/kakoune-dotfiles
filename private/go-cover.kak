declare-option -docstring 'Name of file with coverage profile' str go_cover_file "cover.out"
# declare-option str go_cover_faces "red|green"
set-face global NoCoverage default,rgba:ff000844
set-face global Coverage default,rgba:00ff4444
declare-option str go_cover_faces "NoCoverage|Coverage"

declare-option -hidden range-specs go_cover_ranges
declare-option -hidden str go_cover_script %sh{ echo "${kak_source%%.kak}.pl" }

define-command -override go-cover-update %{
    echo -debug %sh{
        export KAK_BUFFILE="$kak_bufname"
        export FACES="$kak_opt_go_cover_faces"
        "$kak_opt_go_cover_script" < "$kak_opt_go_cover_file"
    }
    evaluate-commands set-option buffer go_cover_ranges %val{timestamp} %sh{
        export KAK_BUFFILE="$kak_bufname"
        export FACES="$kak_opt_go_cover_faces"
        "$kak_opt_go_cover_script" < "$kak_opt_go_cover_file"
    }
}

define-command go-cover-show %{
    go-cover-update
    try %{ add-highlighter buffer/go_cover ranges go_cover_ranges } catch %{ echo already on }
}

define-command go-cover-hide %{
    try %{ remove-highlighter buffer/go_cover } catch %{ echo already hidden }
}
