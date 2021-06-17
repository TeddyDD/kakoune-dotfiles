# form https://gitlab.com/Screwtapello/kakoune-shellcheck/-/blob/master/shellcheck.kak
#
define-command -hidden shellcheck-shell-blocks %{
    evaluate-commands -draft %{
        # Select all the instances of %sh followed by a grouping character.
        # We use hex escapes to avoid messing up Kakoune's nested-brackets
        # parsing.
        execute-keys '%s%sh[\x28\x3C\x5B\x7B]<ret>'

        # We only care about blocks containing at least one character.
        # (otherwise, the following trim-first-and-last-chars trick
        # doesn't work)
        execute-keys <a-k>...<ret>

        # Select up to the matching grouping character,
        # then trim off the first and last characters.
        execute-keys m <a-:>H<a-semicolon>L

        # Check the selected blocks with shellcheck.
        lint-selections -command "shellcheck -s sh -f gcc --exclude SC2154"
    }
}

hook global WinSetOption filetype=kak %{
    alias window lint shellcheck-shell-blocks

    hook -once -always window WinSetOption filetype=.* %{
        unalias window lint
    }
}
