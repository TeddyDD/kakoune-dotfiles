define-command camelcase -docstring '
foo_bar → fooBar
foo-bar → fooBar
foo bar → fooBar' \
%{
  execute-keys '`s[-_<space>]<ret>d~<a-i>w'
}

define-command snakecase -docstring '
fooBar → foo_bar
foo-bar → foo_bar
foo bar → foo_bar' \
%{
  execute-keys '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`'
}

define-command kebabcase -docstring '
fooBarTest → foo-bar
foo_bar → foo-bar
foo bar → foo-bar' \
%{
  execute-keys '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`'
}

define-command pascalcase -docstring '
foo_bar → FooBar
foo-bar → FooBar
foo bar → FooBar' \
%{
  execute-keys 'Z<a-:><a-;>;~zs[-_<space>]<ret>d~<a-i>w'
}
