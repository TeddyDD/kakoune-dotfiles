define-command -override -params 1 lsp-go-tags -docstring %{
    Comma sparated list of tags to use
} %{
	echo -debug set-option global lsp_config "
        [language.go.settings.gopls]
        ""build.buildFlags"" = [""-tags=%arg[@]""]
	"
	set-option global lsp_config "
        [language.go.settings.gopls]
        ""build.buildFlags"" = [""-tags=%arg[@]""]
	"
}

define-command -override lsp-go-format-prefix %{
	set-option global lsp_config "
        [language.go.settings.gopls]
        ""formatting.local"" = ""%sh{ go list -m }""
        ""formatting.gofumpt"" = true
	"
}
