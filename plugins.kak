###########
# PLUGINS #
###########

plug "andreyorst/plug.kak" noload

plug "Delapouite/kakoune-text-objects"
plug "Delapouite/kakoune-auto-percent"
plug "Delapouite/kakoune-buffers" %{
    map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
    map global buffers r ':rofi-buffers<ret>' -docstring 'rofi buffer list'
    map global buffers b ':fzf-buffer<ret>' -docstring 'Fzf buffer list'
}

plug 'delapouite/kakoune-hump' %{
  map global normal '”' ': select-previous-hump<ret>' -docstring 'select prev hump'
  map global normal 'œ' ': select-next-hump<ret>'     -docstring 'select next hump'
  map global normal '“' ': extend-previous-hump<ret>' -docstring 'extend prev hump'
  map global normal 'Œ' ': extend-next-hump<ret>'     -docstring 'extend next hump'
}


plug "Delapouite/kakoune-mirror" %{
	map global user m ' :enter-user-mode -lock mirror<ret>' -docstring 'mirror mode'
}
plug "Delapouite/kakoune-palette"
plug "Delapouite/kakoune-select-view"

plug "occivink/kakoune-find"
plug "occivink/kakoune-expand" %{
    map global normal '+' ': expand<ret>' -docstring 'Expand Selection'
}
plug "occivink/kakoune-sort-selections"

plug "occivink/kakoune-phantom-selection" %{
    map global insert '<c-a>' '<esc>:phantom-selection-iterate-next<ret>'
    map global insert '<c-w>' '<esc>:phantom-selection-select-all<ret>'
    map global normal '<c-a>' ':phantom-selection-iterate-next<ret>'
    map global normal '<c-q>' ':phantom-selection-clear'
    map global normal '<c-q>' '<esc>:phantom-selection-clear<ret>'
    map global normal '<c-w>' ':phantom-selection-select-all<ret>'
}

plug "occivink/kakoune-sudo-write"
plug "occivink/kakoune-vertical-selection"

plug "danr/kakoune-easymotion" commit 40d73d  %{
    map global user j ' :enter-user-mode easymotion<ret>' -docstring 'easy motion'
}

plug "alexherbo2/auto-pairs.kak" %{
    map global user -docstring "surround with" r ': auto-pairs-surround<ret>'
}
plug "alexherbo2/distraction-free.kak"
plug "alexherbo2/connect.kak"
plug "alexherbo2/select.kak"
plug "alexherbo2/split-object.kak" %{
    map global normal <a-I> ': enter-user-mode split-object<ret>'
    map global user I ': enter-user-mode split-object<ret>' -docstring 'Split objetcs'
}

plug "h-youhei/kakoune-each-line-selection"
plug "h-youhei/kakoune-surround" %{
    map global normal <a-R> ': surround<ret>' -docstring 'surround'
}
plug "h-youhei/kakoune-close-tag" %{
	define-command close-tag-enable %{
		map global insert '<c-t>' '<esc>:close-tag<ret>i'
	}
}

plug "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <F2> <a-i>w:mark-word<ret>
    map global normal <F3> :mark-clear<ret>
}

plug "https://gitlab.com/notramo/crystal.kak"

# plug "Skytrias/gdscript-kak"

plug "andreyorst/smarttab.kak"
plug "andreyorst/kakoune-snippet-collection"
plug "andreyorst/fzf.kak" config %{
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
} defer "fzf" %{
    set-option global fzf_highlight_command 'chroma -f terminal16m -s solarized-light {}'
    set-option global fzf_file_command 'fd -I --type f --follow'
    set-option global fzf_sk_grep_command "rg -niL"
}

plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
}

plug "laelath/kakoune-show-matching-insert" %{
    hook global InsertBegin .* %{
        add-highlighter window/matching_prev_char ranges show_matching_insert
    }
    hook global InsertEnd .* %{
        remove-highlighter window/matching_prev_char
    }
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
    wiki_setup "/home/teddy/Notatki/wiki"
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

plug "TeddyDD/kakoune-edit-or-dir" %{
    unalias global e
    alias global e edit-or-dir
}

plug "TeddyDD/yank-ring.kak" %{
    map global user y :yank-ring-open<ret> -docstring 'yank ring'
}

plug "TeddyDD/kakoune-pixilang" %{
	set-option global pixilang_path "~/Pobrane/pixilang/pixilang/linux_x86_64/pixilang"
}

plug "robertmeta/nofrils-kakoune" theme
plug "ath3/explain-shell.kak"
plug "chambln/kakoune-smart-quotes"
