# Syntax sugar

provide-module 'filetypes-sugar' %¼

define-command for-extension -params 2 \
  -docstring "for-extension EXT COMMAND
  wrapper for global BufCreate hook
  " \
%{
    hook global BufCreate ".*\.%arg{1}$" %arg{2}
}


define-command for-filetype -params 2 \
  -docstring "for-filetype FILETYPE COMMAND
  wrapper for global WinSetOption filetype hook
  " \
%{
    hook global WinSetOption "filetype=%arg{1}" %arg{2}
}

require-module kak
add-highlighter shared/kakrc/code/filetypes_keywords regex '\b(for-extension|for-filetype)\b' 0:keyword

¼
