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
