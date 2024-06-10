{ lib, config, ... }:
let
  cfg = config.presets.languages.angular;
in
{
  options.presets.languages.angular = {
    enable = lib.mkEnableOption "Angular";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.enabledServers = [
        {
          name = "angularls";
          extraOptions = {
            cmd = [
              "ngserver"
              "--stdio"
              "--tsProbeLocations"
              ""
              "--ngProbeLocations"
              ""
            ];
            on_new_config = {
              __raw = ''
                function(new_config, new_root_dir)
                  new_config.cmd = {
                    new_root_dir .. "/node_modules/@angular/language-server/bin/ngserver",
                    "--stdio",
                    "--tsProbeLocations",
                    new_root_dir .. "/node_modules",
                    "--ngProbeLocations",
                    new_root_dir .. "/node_modules",
                  }
                end
              '';
            };
            filetypes = [
              "typescript"
              "html"
              "typescriptreact"
              "typescript.tsx"
              "angular"
              "html.angular"
            ];
            on_attach = {
              __raw = ''
                function(client, bufnr)
                  if vim.bo[bufnr].filetype == "html" then
                    vim.bo[bufnr].filetype = "angular"
                  end
                end
              '';
            };
          };
        }
      ];
    };
  };
}
