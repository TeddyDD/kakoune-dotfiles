define-command -override -params 1 lsp-go-tags %{
	echo -debug set-option global lsp_config "
        [language.go.settings.gopls]
        ""build.buildFlags"" = [""-tags=%arg[@]""]
	"
}
