###########
# PLUGINS #
###########

plug "andreyorst/plug.kak" noload

plug "gustavo-hms/luar"

plug "kakoune-editor/kakoune-extra-filetypes"

plug "https://gitlab.com/listentolist/kakoune-fandt" %{
	require-module fandt
}

plug "Delapouite/kakoune-text-objects"
plug "Delapouite/kakoune-auto-percent"
plug "Delapouite/kakoune-buffers" %{
    map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
    map global buffers b ':fzf-buffer<ret>' -docstring 'Fzf buffer list'
}

plug 'delapouite/kakoune-hump' %{
  map global normal '”' ': select-previous-hump<ret>' -docstring 'select prev hump'
  map global normal 'œ' ': select-next-hump<ret>'     -docstring 'select next hump'
  map global normal '“' ': extend-previous-hump<ret>' -docstring 'extend prev hump'
  map global normal 'Œ' ': extend-next-hump<ret>'     -docstring 'extend next hump'
}

plug "Delapouite/kakoune-mirror" config %{
	map global user m ': enter-user-mode -lock mirror<ret>' -docstring 'mirror mode'
}

plug "Delapouite/kakoune-palette"
plug "Delapouite/kakoune-select-view"

plug "occivink/kakoune-find"
plug "occivink/kakoune-expand" %{
    map global normal '+' ': expand<ret>' -docstring 'Expand Selection'
}
plug "occivink/kakoune-sort-selections"

plug "occivink/kakoune-phantom-selection"

plug "occivink/kakoune-sudo-write"
plug "occivink/kakoune-vertical-selection"

plug "kakounedotcom/prelude.kak"
plug "kakounedotcom/connect.kak" config %{
	require-module connect
}
plug "TeddyDD/terminal-mode.kak" %{
    require-module terminal-mode
    map global user <tab> ': enter-user-mode terminal<ret>t' -docstring 'Terminal'
}

plug "TeddyDD/split-object.kak" %{
    require-module split-object
    map global normal <a-I> ': enter-user-mode split-object<ret>'
    map global user I ': enter-user-mode split-object<ret>' -docstring 'Split objetcs'
}

plug "h-youhei/kakoune-each-line-selection"
plug "h-youhei/kakoune-surround" %{
    map global normal <a-R> ': surround<ret>' -docstring 'surround'
}

plug "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <F2> <a-i>w:mark-word<ret>
    map global normal <F3> :mark-clear<ret>
}

plug "andreyorst/smarttab.kak"
plug "andreyorst/kakoune-snippet-collection"
plug "andreyorst/fzf.kak" config %{
    require-module fzf
    require-module fzf-buffer
    require-module fzf-ctags
    require-module fzf-git
    require-module fzf-vcs
    require-module fzf-grep
    require-module fzf-sk-grep
    require-module fzf-project
    require-module fzf-file
    set-option global fzf_highlight_command 'chroma -f terminal16m -s solarized-light {}'
    set-option global fzf_file_command 'fd -I --type f --follow'
    set-option global fzf_sk_grep_command "rg -niL"
    set-option global fzf_use_main_selection false
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
}

plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
}

plug "laelath/kakoune-show-matching-insert" %{
    add-highlighter global/ ranges show_matching_insert
}

plug "eraserhd/kak-ansi"

plug "eraserhd/parinfer-rust" do %{
    cargo build --release
    cargo install --force
} %{
    hook -group parinfer global WinSetOption filetype=lisp %{
        parinfer -if-enabled -paren
        hook -group parinfer window NormalKey .* %{ parinfer -if-enabled -smart }
        hook -group parinfer window InsertChar .* %{ parinfer -if-enabled -smart }
        hook -group parinfer window InsertDelete .* %{ parinfer -if-enabled -smart }
    }
}

plug "occivink/kakoune-snippets" config %{
    set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
    set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-cfdg/snippets"
    set-option global snippets_auto_expand false
    map global insert '<tab>' "z<a-;>: snippets-expand-or-jump 'tab'<ret>"
    map global normal '<tab>' ": snippets-expand-or-jump 'tab'<ret>"

    hook global InsertCompletionShow .* %{
        try %{
            execute-keys -draft 'h<a-K>\h<ret>'
            map window insert '<ret>' "z<a-;>: snippets-expand-or-jump 'ret'<ret>"
        }
    }

    hook global InsertCompletionHide .* %{
        unmap window insert '<ret>' "z<a-;>: snippets-expand-or-jump 'ret'<ret>"
    }

    define-command snippets-expand-or-jump -params 1 %{
        execute-keys <backspace>
        try %{ snippets-expand-trigger %{
            set-register / "%opt{snippets_triggers_regex}\z"
            execute-keys 'hGhs<ret>'
        }} catch %{
            snippets-select-next-placeholders
        } catch %sh{
            printf "%s\n" "execute-keys -with-hooks <$1>"
        } catch %{
            nop
        }
    }
}

# My plugins

plug "TeddyDD/kakoune-wiki" %{
    wiki-setup %sh{ echo  "$HOME/Notatki/wiki" }
    map global user w :wiki<space> -docstring 'wiki'

    define-command diary %{
        edit ~/Notatki/wiki/dziennik-public.md
        execute-keys 'geo<esc>! date "+%Y-%m-%d: %H:%M"<ret>k'
        underline -
    }
}

plug "TeddyDD/kakoune-lf"
plug "TeddyDD/kakoune-cfdg"
plug "TeddyDD/kakoune-mint"
plug "TeddyDD/kakoune-selenized" theme

plug "TeddyDD/distraction-free.kak"
plug "TeddyDD/explore.kak"
plug "TeddyDD/select.kak"
plug "TeddyDD/yank-ring.kak" %{
    map global user y :yank-ring-open<ret> -docstring 'yank ring'
}

plug "TeddyDD/kakoune-pixilang" %{
	set-option global pixilang_path "~/Pobrane/pixilang/pixilang/linux_x86_64/pixilang"
}

plug "robertmeta/nofrils-kakoune" theme
plug "chambln/kakoune-smart-quotes"

plug 'jjk96/kakoune-rainbow' %{
	set-option global rainbow_faces red green yellow blue magenta cyan
}

plug "andreyorst/kaktree" config %{
    map global user 't' ": kaktree-toggle<ret>" -docstring "toggle filetree panel"
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}
plug "https://gitlab.com/listentolist/kakoune-table"
plug "matthias-margush/tug"
plug "https://gitlab.com/Screwtapello/kakoune-ghwiki"

plug "ftonneau/digraphs.kak" %{
    set-option global digraphs_path 'plugins/digraphs.kak'
    digraphs-enable-on <a-d> <a-D>
}
