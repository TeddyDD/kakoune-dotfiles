define-command -override -params 1.. go-modify-tags %{
    # nop %sh{ gomodifytags -w -file "$kak_buffile" -offset "$kak_cursor_byte_offset" -add-tags "$@" }
    evaluate-commands -draft -no-hooks -save-regs '|' %{
        set-register '|' "
            tags_in=""$(mktemp ""${TMPDIR:-/tmp}""/kak-go-tags.XXXXXX)""
            tags_out=""$(mktemp ""${TMPDIR:-/tmp}""/kak-go-tags.XXXXXX)""
            clean() {
                rm -f ""$tags_in"" ""$tags_out""
            }
            trap clean EXIT INT

            cat >""$tags_in""
            eval gomodifytags -file ""$tags_in"" \
                -offset ""%val{cursor_byte_offset}"" \
                %arg{@}
            if [ $? -eq 0 ]
            then
                cat ""$tags_out""
            else
                printf 'eval -client %%s %%%%{ fail gomodifytags returned an error %%s }\n' ""$kak_client"" ""$?"" |
                    kak -p ""$kak_session""
                cat ""$tags_in""
            fi
        "
        execute-keys '%|<ret>'
    }
}

define-command -params 1.. go-add-tags %{
   evaluate-commands %sh{
       echo go-modify-tags "%{ -add-tags '$(echo $@ | tr ' ' ',')' }"
   } 
}

define-command -params 1.. go-remove-tags %{
   evaluate-commands %sh{
       echo go-modify-tags "%{ -remove-tags '$(echo $@ | tr ' ' ',')' }"
   } 
}

define-command -params 1.. go-add-options %{
   evaluate-commands %sh{
       echo go-modify-tags "%{ -add-options '$(echo $@ | tr ' ' ',')' }"
   } 
}

define-command -params 1.. go-remove-options %{
   evaluate-commands %sh{
       echo go-modify-tags "%{ -remove-options '$(echo $@ | tr ' ' ',')' }"
   } 
}
