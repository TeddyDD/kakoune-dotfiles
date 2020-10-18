
define-command yaml-indent %{
    require-module luar
    require-module yaml-indent
    try %{
        add-highlighter window/yaml_indent ranges yaml_indent_regions
        hook -group yaml-indent window NormalIdle .* %{ yaml-indent-compute-ranges }
        hook -group yaml-indent window InsertIdle .* %{ yaml-indent-compute-ranges }
    }
}

provide-module yaml-indent %$

declare-option -hidden range-specs yaml_indent_regions

define-command yaml-indent-disable %{
    try %{
        remove-highlighter window/yaml_indent
        remove-hooks window yaml-indent
    }
}

define-command -hidden yaml-indent-compute-ranges %{
    set-option window yaml_indent_regions %val{timestamp}
    evaluate-commands -draft %{
        execute-keys ';%s^\h+<ret>'
        lua %val{selections_desc} %{
            local floor = math.floor
            local pattern = "(%d+).%d+,%d+.(%d+)"
            local faces = {
                "bright-red",
                "bright-green",
                "bright-yellow",
                "bright-blue",
                "bright-magenta",
                "bright-cyan",
            }
            local faces_len = #faces
            for _,sel in ipairs(arg) do
                local _,_,line,ce = string.find(sel, pattern)
                local line = floor(line)
                local depth = 1
                for i=1,ce,2 do
                    local desc = string.format("%s.%s,%s.%s|%s",
                        line,
                        floor(i),
                        line,
                        floor(i+1),
                        faces[(depth - 1) % faces_len + 1]
                    )
                    depth = depth + 1
                    kak.set_option("-add","window", "yaml_indent_regions", desc)
                end
            end
        }
    }
}

$
