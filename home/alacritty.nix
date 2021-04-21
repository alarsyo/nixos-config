{ config, lib, ... }:
let
  cfg = config.my.home.alacritty;
  alacrittyTheme = config.my.theme.alacrittyTheme;
in
{
  options.my.home.alacritty.enable = lib.mkEnableOption "Alacritty terminal";

  config.programs.alacritty = lib.mkIf cfg.enable {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        decorations = "none";
      };

      font = {
        normal = {
          family = "Input Mono Narrow";
        };
        size = 9.0;
      };

      colors = alacrittyTheme;
    };
  };
}
