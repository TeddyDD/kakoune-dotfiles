###########
# PLUGINS #
###########


source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://git.sr.ht/~jdugan6240/kak-bundle

bundle luar https://github.com/gustavo-hms/luar
bundle kakoune-extra-filetypes https://github.com/kakoune-editor/kakoune-extra-filetypes

bundle kakoune-fandt https://github.com/listentolist/kakoune-fandt %{
    require-module fandt
}

bundle kakoune-text-objects https://github.com/Delapouite/kakoune-text-objects
bundle kakoune-auto-percent https://github.com/Delapouite/kakoune-auto-percent

bundle kakoune-buffers https://github.com/Delapouite/kakoune-buffers %{
    map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
    map global buffers b ':fzf-buffer<ret>' -docstring 'Fzf buffer list'
}

bundle kakoune-hump https://github.com/delapouite/kakoune-hump %{
  map global normal '”' ': select-previous-hump<ret>' -docstring 'select prev hump'
  map global normal 'œ' ': select-next-hump<ret>'     -docstring 'select next hump'
  map global normal '“' ': extend-previous-hump<ret>' -docstring 'extend prev hump'
  map global normal 'Œ' ': extend-next-hump<ret>'     -docstring 'extend next hump'
}
bundle kakoune-mirror https://github.com/Delapouite/kakoune-mirror %{
    map global user m ': enter-user-mode -lock mirror<ret>' -docstring 'mirror mode'
}
bundle kakoune-palette https://github.com/Delapouite/kakoune-palette
bundle kakoune-select-view https://github.com/Delapouite/kakoune-select-view
bundle kakoune-find https://github.com/occivink/kakoune-find
bundle kakoune-expand https://github.com/occivink/kakoune-expand %{
    map global normal '+' ': expand<ret>' -docstring 'Expand Selection'
}

bundle kakoune-sort-selections https://github.com/occivink/kakoune-sort-selections
bundle kakoune-phantom-selection https://github.com/occivink/kakoune-phantom-selection
bundle kakoune-sudo-write https://github.com/occivink/kakoune-sudo-write
bundle kakoune-vertical-selection https://github.com/occivink/kakoune-vertical-selection

bundle terminal-mode.kak  https://github.com/TeddyDD/terminal-mode.kak %{
    require-module terminal-mode
    map global user <tab> ': enter-user-mode terminal<ret>t' -docstring 'Terminal'
}
bundle split-object.kak https://github.com/TeddyDD/split-object.kak %{
    map global normal <a-I> ': enter-user-mode select<ret>'
    map global user I ': enter-user-mode select<ret>' -docstring 'Split objetcs'
}
bundle kakoune-each-line-selection https://github.com/h-youhei/kakoune-each-line-selection
bundle kakoune-surround https://github.com/h-youhei/kakoune-surround %{
    map global normal <a-R> ': surround<ret>' -docstring 'surround'
}
bundle kakoune-mark" "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <F2> <a-i>w:mark-word<ret>
    map global normal <F3> :mark-clear<ret>
}
bundle smarttab.kak https://github.com/andreyorst/smarttab.kak
bundle fzf.kak https://github.com/andreyorst/fzf.kak %{
    require-module fzf
    require-module fzf-buffer
    require-module fzf-ctags
    require-module fzf-git
    require-module fzf-vcs
    require-module fzf-grep
    require-module fzf-project
    require-module fzf-file
    set-option global fzf_highlight_command 'chroma -f terminal16m -s solarized-light {}'
    set-option global fzf_file_command 'fd --type f --follow'
    set-option global fzf_grep_command 'rg'
    set-option global fzf_use_main_selection false
    map global fzf g ': fzf-grep<ret>'
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
}
bundle tagbar.kak https://github.com/andreyorst/tagbar.kak %{
    hook global ModuleLoaded tagbar %{
        set-option global tagbar_sort false
        set-option global tagbar_size 40
        set-option global tagbar_display_anon false
    }
}
bundle kakoune-show-matching-insert https://github.com/laelath/kakoune-show-matching-insert %{
    add-highlighter global/ ranges show_matching_insert
}
bundle kak-ansi https://github.com/eraserhd/kak-ansi
bundle parinfer-rust https://github.com/eraserhd/parinfer-rust %{
    hook global WinSetOption filetype=(clojure|lisp|scheme|racket) %{
        parinfer-enable-window -smart
    }
} %{
    cargo install --force --path .
}
bundle kakoune-cfdg https://github.com/TeddyDD/kakoune-cfdg
bundle kakoune-mint https://github.com/TeddyDD/kakoune-mint
# bundle kakoune-selenized https://github.com/TeddyDD/kakoune-selenized %{} %{

# }
bundle distraction-free.kak https://github.com/TeddyDD/distraction-free.kak
bundle kakoune-smart-quotes https://github.com/chambln/kakoune-smart-quotes
bundle kakoune-rainbow https://github.com/jjk96/kakoune-rainbow %{
    set-option global rainbow_faces red green yellow blue magenta cyan
}
bundle kaktree "https://git.sr.ht/~teddy/kaktree" %{
    map global user 't' ": kaktree-toggle<ret>" -docstring "toggle filetree panel"
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
    set-option global kaktree_dir_icon_open  '⠀'
    set-option global kaktree_dir_icon_close '⠀'
    set-option global kaktree_file_icon      '⠀'
    set-face global kaktree_icon_face function
}
bundle kakoune-table "https://gitlab.com/listentolist/kakoune-table"
bundle tug https://github.com/matthias-margush/tug
bundle digraphs.kak https://github.com/ftonneau/digraphs.kak %{
    set-option global digraphs_path 'bundle peneirains/digraphs.kak'
    digraphs-enable-on <a-d> <a-D>
}
bundle peneira https://github.com/gustavo-hms/peneira %{
    hook global ModuleLoaded peneira %{
        set-face global PeneiraFlag default
    }
}
bundle kak-subvert https://github.com/dmerejkowsky/kak-subvert %{} %{
    cargo build --release
    cargo install --path .
}
bundle harpoon.kak "https://git.sr.ht/~raiguard/harpoon.kak" %{
    map global normal <c-F1> ": harpoon-nav 1 true<ret>" -docstring "Add file to 1"
    map global normal <c-F2> ": harpoon-nav 2 true<ret>" -docstring "Add file to 2"
    map global normal <c-F3> ": harpoon-nav 3 true<ret>" -docstring "Add file to 3"
    map global normal <c-F4> ": harpoon-nav 4 true<ret>" -docstring "Add file to 4"
    map global normal <c-F5> ": harpoon-nav 5 true<ret>" -docstring "Add file to 5"
    map global normal <c-F6> ": harpoon-nav 6 true<ret>" -docstring "Add file to 6"
    map global normal <c-F7> ": harpoon-nav 7 true<ret>" -docstring "Add file to 7"
    map global normal <c-F8> ": harpoon-nav 8 true<ret>" -docstring "Add file to 8"
    map global normal <c-F9> ": harpoon-nav 9 true<ret>" -docstring "Add file to 9"
}
bundle kakoune-multi-file https://github.com/natasky/kakoune-multi-file
bundle kakoune-pixilang https://github.com/TeddyDD/kakoune-pixilang
bundle kakoune-snippets 'git clone https://github.com/occivink/kakoune-snippets && cd kakoune-snippets && git checkout 9c96e64a' %{
    set-option -add global snippets_directories "%val{config}/bundle/kakoune-snippet-collection/snippets"
    set-option global snippets_auto_expand false
    define-command -hidden snippets-custom-trigger %{
        try %{
          snippets-expand-trigger %{
            reg / "%opt{snippets_triggers_regex}"
            # select to the beginning of the line, and then subselect for one of the triggers
            execute-keys ';bs<ret>'
          }
          try %{ execute-keys <esc>_<a-d>i }
        } catch %{
            snippets-select-next-placeholders
            try %{ execute-keys <esc>_<a-d>i } catch %{ execute-keys i }
        }
    }
  map global insert '<c-s>' '<a-;>: snippets-custom-trigger<ret>'
  # map global insert '<c-n>' '<a-;>: snippets-select-next-placeholders<ret><esc>'
  # map global normal '<c-n>' ': snippets-select-next-placeholders<ret>'
}
bundle kakoune-snippet-collection https://github.com/andreyorst/kakoune-snippet-collection
bundle kak-preservecase" https://github.com/pimpale/kak-preservecase %{} %{
    cargo install --locked --force --path .
}
bundle diff.kak https://github.com/harryoooooooooo/diff.kak %{
    diff-enable-auto-detect
}
