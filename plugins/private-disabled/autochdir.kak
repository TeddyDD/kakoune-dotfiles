##
## autochdir.kak by wheatdog
## Automatically change server's working directory according to the current focus buffer
## To turn on this option, add `set global autochdir true` in your kakrc
##

decl bool autochdir
decl str working_folder

def -hidden \
    autochdir-wrapper %{ evaluate-commands  %sh{
        if [ "${kak_opt_autochdir}" = "true" ] && [ -n "${kak_opt_working_folder}" ] && [ -d "${kak_opt_working_folder}" ]; then
            printf 'cd %s\n' "${kak_opt_working_folder}"
        fi
} }

#def -file-completion -params ..1 -docstring %{change-directory! [<directory>] : like change-directory, but also update the buffer's working directory} \
#    change-directory! %{ %sh{
#        printf 'cd %s\n' "$@"
#    } 
#    set buffer working_folder %sh{pwd}
#}

hook global BufCreate .* %{
    set buffer working_folder %sh{ 
        if [ "${kak_buffile##*/}" = "COMMIT_EDITMSG" ]; then
            git rev-parse --show-toplevel
        else
            dirname ${kak_buffile}
        fi 
    }
    autochdir-wrapper
}

hook global WinDisplay .* %{ autochdir-wrapper }
hook global FocusIn .* %{ autochdir-wrapper }

