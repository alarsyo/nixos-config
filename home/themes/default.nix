{ config, lib, ... }:
with lib;
let
  themeType = types.submodule {
    options = {
      alacrittyTheme = mkOption {
        type = import ./alacritty.nix { inherit lib; };
        default = {};
      };
      i3Theme = mkOption {
        type = import ./i3.nix { inherit lib; };
      };
    };
  };
in
{
  options.my.theme = mkOption {
      type = themeType;
  };

  options.my.themes = mkOption {
    type = with types; attrsOf themeType;
  };

  config.my.themes = {
    solarizedLight = import ./solarizedLight;
  };
}
