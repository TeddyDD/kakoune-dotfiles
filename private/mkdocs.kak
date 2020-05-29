define-command -override mdinfofile %{
    execute-keys  %{
        <a-:><a-;>
        J
        _
        :mdfence<ret>
        <a-a>g<a-x><gt>
        <a-:><a-;>
        kx_i"<esc>a"<esc>
        <a-h>i!!!<space>info<space><esc>
    }
}

define-command -override mdtitle %{
    execute-keys %{ x|titlecase<ret> }
}
