###########
# PLUGINS #
###########

plug-chain "andreyorst/plug.kak" noload \
plug "gustavo-hms/luar" \
plug "kakoune-editor/kakoune-extra-filetypes" \
plug "https://gitlab.com/listentolist/kakoune-fandt" %{
	require-module fandt
} \
plug "Delapouite/kakoune-text-objects" \
plug "Delapouite/kakoune-auto-percent" \
plug "Delapouite/kakoune-buffers" %{
    map global user b ':enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
    map global buffers b ':fzf-buffer<ret>' -docstring 'Fzf buffer list'
} \
plug 'delapouite/kakoune-hump' %{
  map global normal '”' ': select-previous-hump<ret>' -docstring 'select prev hump'
  map global normal 'œ' ': select-next-hump<ret>'     -docstring 'select next hump'
  map global normal '“' ': extend-previous-hump<ret>' -docstring 'extend prev hump'
  map global normal 'Œ' ': extend-next-hump<ret>'     -docstring 'extend next hump'
} \
plug "Delapouite/kakoune-mirror" config %{
	map global user m ': enter-user-mode -lock mirror<ret>' -docstring 'mirror mode'
} \
plug "Delapouite/kakoune-palette" \
plug "Delapouite/kakoune-select-view" \
plug "occivink/kakoune-find" \
plug "occivink/kakoune-expand" %{
    map global normal '+' ': expand<ret>' -docstring 'Expand Selection'
} \
plug "occivink/kakoune-sort-selections" \
plug "occivink/kakoune-phantom-selection" \
plug "occivink/kakoune-sudo-write" \
plug "occivink/kakoune-vertical-selection" \
plug "TeddyDD/terminal-mode.kak" %{
    require-module terminal-mode
    map global user <tab> ': enter-user-mode terminal<ret>t' -docstring 'Terminal'
} \
plug "TeddyDD/split-object.kak" %{
    map global normal <a-I> ': enter-user-mode select<ret>'
    map global user I ': enter-user-mode select<ret>' -docstring 'Split objetcs'
} \
plug "h-youhei/kakoune-each-line-selection" \
plug "h-youhei/kakoune-surround" %{
    map global normal <a-R> ': surround<ret>' -docstring 'surround'
} \
plug "https://gitlab.com/fsub/kakoune-mark" %{
    map global normal <F2> <a-i>w:mark-word<ret>
    map global normal <F3> :mark-clear<ret>
} \
plug "andreyorst/smarttab.kak" \
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
    set-option global fzf_file_command 'fd --type f --follow'
    set-option global fzf_sk_grep_command "rg -niL"
    set-option global fzf_use_main_selection false
    map global fzf g ': fzf-sk-grep<ret>'
    map global user f ': fzf-mode<ret>' -docstring 'fzf'
} \
plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
} \
plug "laelath/kakoune-show-matching-insert" %{
    add-highlighter global/ ranges show_matching_insert
} \
plug "eraserhd/kak-ansi" \
plug "eraserhd/parinfer-rust" do %{
    cargo install --force --path .
} config %{
    hook global WinSetOption filetype=(clojure|lisp|scheme|racket) %{
        parinfer-enable-window -smart
    }
} \
plug "TeddyDD/kakoune-cfdg" \
plug "TeddyDD/kakoune-mint" \
plug "TeddyDD/kakoune-selenized" theme \
plug "TeddyDD/distraction-free.kak" \
plug "chambln/kakoune-smart-quotes" \
plug 'jjk96/kakoune-rainbow' %{
	set-option global rainbow_faces red green yellow blue magenta cyan
} \
plug "andreyorst/kaktree" config %{
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
} \
plug "https://gitlab.com/listentolist/kakoune-table" \
plug "matthias-margush/tug" \
plug "ftonneau/digraphs.kak" %{
    set-option global digraphs_path 'plugins/digraphs.kak'
    digraphs-enable-on <a-d> <a-D>
} \
plug "gustavo-hms/peneira" defer "peneira" %{
    set-face global PeneiraFlag default
} \
plug "dmerejkowsky/kak-subvert" do %{
    cargo build --release
    cargo install --path .
} \
plug "https://git.sr.ht/~raiguard/harpoon.kak" %{
    map global normal <c-F1> ": harpoon-nav 1 true<ret>" -docstring "Add file to 1"
    map global normal <c-F2> ": harpoon-nav 2 true<ret>" -docstring "Add file to 2"
    map global normal <c-F3> ": harpoon-nav 3 true<ret>" -docstring "Add file to 3"
    map global normal <c-F4> ": harpoon-nav 4 true<ret>" -docstring "Add file to 4"
    map global normal <c-F5> ": harpoon-nav 5 true<ret>" -docstring "Add file to 5"
    map global normal <c-F6> ": harpoon-nav 6 true<ret>" -docstring "Add file to 6"
    map global normal <c-F7> ": harpoon-nav 7 true<ret>" -docstring "Add file to 7"
    map global normal <c-F8> ": harpoon-nav 8 true<ret>" -docstring "Add file to 8"
    map global normal <c-F9> ": harpoon-nav 9 true<ret>" -docstring "Add file to 9"
} \
}
