{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.languages.svelte;
in
{
  options.presets.languages.svelte = {
    enable = lib.mkEnableOption "Svelte";
  };

  config = lib.mkIf cfg.enable {
    plugins.lsp.servers.svelte = {
      enable = true;
      settings.typescript.inlayHints = {
        parameterNames.enabled = "all";
        parameterTypes.enabled = true;
        variableTypes.enabled = true;
        propertyDeclarationTypes.enabled = true;
        functionLikeReturnTypes.enabled = true;
        enumMemberValues.enabled = true;
      };
    };
  };
}
