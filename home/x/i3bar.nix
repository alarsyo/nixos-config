{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.x.enable;
in
{
  config = lib.mkIf isEnabled {
    home.packages = with pkgs; [
      alsaUtils # Used by `sound` block
      lm_sensors # Used by `temperature` block
    ];

    programs.i3status-rust = {
      enable = true;

      bars = {
        top = {
          theme = "gruvbox-light";
        };
      };
    };
  };
}
