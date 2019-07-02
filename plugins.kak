###########
# PLUGINS #
###########

plug "andreyorst/plug.kak" noload

plug "https://github.com/Delapouite/kakoune-text-objects"
plug "https://github.com/Delapouite/kakoune-auto-percent"
plug "https://github.com/Delapouite/kakoune-buffers" %{
    map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
    map global buffers r ':rofi-buffers<ret>' -docstring 'rofi buffer list'
    map global buffers b ':fzf-buffer<ret>' -docstring 'Fzf buffer list'
}

# plug "https://github.com/Delapouite/kakoune-i3"
plug "https://github.com/Delapouite/kakoune-mirror"
plug "https://github.com/Delapouite/kakoune-palette"
plug "https://github.com/Delapouite/kakoune-select-view"

plug "https://github.com/occivink/kakoune-find"
plug "https://github.com/occivink/kakoune-expand"

plug "https://github.com/occivink/kakoune-phantom-selection" %{
    map global insert '<c-a>' '<esc>:phantom-sel-iterate-next<ret>'
    map global insert '<c-w>' '<esc>:phantom-sel-select-all<ret>'
    map global normal '<c-a>' ':phantom-sel-iterate-next<ret>'
    map global normal '<c-q>' ':phantom-sel-clear'
    map global normal '<c-q>' '<esc>:phantom-sel-clear<ret>'
    map global normal '<c-w>' ':phantom-sel-select-all<ret>'
}

plug "https://github.com/occivink/kakoune-sudo-write"
plug "https://github.com/occivink/kakoune-vertical-selection"

plug "https://github.com/danr/kakoune-easymotion" commit 40d73d  %{
    declare-user-mode easy-motion
    map global easy-motion j ' :easy-motion-j<ret>'
    map global easy-motion k ' :easy-motion-k<ret>'
    map global easy-motion w ' :easy-motion-w<ret>'
    map global easy-motion b ' :easy-motion-b<ret>'
    map global easy-motion W ' :easy-motion-W<ret>'
    map global easy-motion B ' :easy-motion-B<ret>'
    map global easy-motion f ' :easy-motion-f<ret>'
    map global easy-motion <a-f> ' :easy-motion-alt-f<ret>'
    map global user j ' :enter-user-mode easy-motion<ret>' -docstring 'easy motion'
}

plug "https://github.com/alexherbo2/auto-pairs.kak" %{
    map global user -docstring "surround with" r ': auto-pairs-surround<ret>'
}
plug "https://github.com/alexherbo2/distraction-free.kak"
plug "https://github.com/alexherbo2/connect.kak"
plug "https://github.com/alexherbo2/select.kak"
plug "https://github.com/alexherbo2/split-object.kak" %{
    map global normal <a-I> ': enter-user-mode split-object<ret>'
    map global user I ': enter-user-mode split-object<ret>' -docstring 'Split objetcs'
}

plug "https://github.com/h-youhei/kakoune-each-line-selection"
plug "https://github.com/h-youhei/kakoune-surround" %{
    map global normal <a-R> ': surround<ret>' -docstring 'surround'
}
plug "https://github.com/h-youhei/kakoune-close-tag" %{
	define-command close-tag-enable %{
		map global insert '<c-t>' '<esc>:close-tag<ret>i'
	}
}

plug "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <F2> <a-i>w:mark-word<ret>
    map global normal <F3> :mark-clear<ret>
}

plug "https://gitlab.com/notramo/crystal.kak"

# plug "https://github.com/Skytrias/gdscript-kak"

plug "andreyorst/smarttab.kak"
plug "andreyorst/kakoune-snippet-collection"
plug "https://github.com/andreyorst/fzf.kak" config %{
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
} defer "fzf" %{
    set-option global fzf_highlight_cmd 'chroma -f terminal16m -s solarized-light {}'
    set-option global fzf_file_command 'fd -I --type f --follow'
    set-option global fzf_sk_grep_command "rg -niL"
}

plug "https://github.com/laelath/kakoune-show-matching-insert" %{
    hook global KakBegin .* %{
        add-highlighter global/matching_prev_char ranges show_matching_insert
    }
}


plug "https://github.com/eraserhd/kak-ansi"

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

plug "https://github.com/TeddyDD/kakoune-wiki" %{
    wiki_setup "/home/teddy/Notatki/wiki"
    map global user w :wiki<space> -docstring 'wiki'

    define-command diary %{
        edit ~/Notatki/wiki/dziennik-public.md
        execute-keys 'geo<esc>! date "+%Y-%m-%d: %H:%M"<ret>k'
        underline -
    }
}

plug "https://github.com/TeddyDD/kakoune-lf"
plug "https://github.com/TeddyDD/kakoune-cfdg"
plug "https://github.com/TeddyDD/kakoune-mint"
plug "https://github.com/TeddyDD/kakoune-selenized" theme

plug "https://github.com/TeddyDD/kakoune-edit-or-dir" %{
    unalias global e
    alias global e edit-or-dir
}

plug "https://github.com/TeddyDD/yank-ring.kak" %{
    map global user y :yank-ring-open<ret> -docstring 'yank ring'
}

plug "TeddyDD/kakoune-pixilang" %{
	set-option global pixilang_path "~/Pobrane/pixilang/pixilang/linux_x86_64/pixilang"
}

plug "https://github.com/robertmeta/nofrils-kakoune" theme
plug "ath3/explain-shell.kak"
