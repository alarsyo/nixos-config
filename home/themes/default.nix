{ config, lib, ... }:
with lib;
let
  themeType = types.submodule {
    options = {
      i3Theme = mkOption {
        type = import ./i3.nix { inherit lib; };
      };
    };
  };
in
{
  options.my.home = {
    theme = mkOption {
      type = themeType;
    };

    themes = mkOption {
      type = with types; attrsOf themeType;
    };
  };

  config.my.home.themes = {
    solarizedLight = import ./solarizedLight;
  };
}
