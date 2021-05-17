provide-module control-flow %¼
    require-module luar
    define-command for -params 4.. %{
        lua %arg{@} %{
            local elm_name = table.remove(arg, 1)
            table.remove(arg,1) -- drop 'in'
            local body = table.remove(arg, #arg)
            for _,elm in ipairs(arg) do
                local b = string.gsub(body, "%%val{" .. elm_name .. "}",elm)
                kak.evaluate_commands(b)
            end
        }
    }

    define-command test-control-flow %{
        for buffer in %val{buflist} %{
            echo -debug %val{buffer}
        }
    }
¼

