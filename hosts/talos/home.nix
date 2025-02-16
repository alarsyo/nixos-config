{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOptionDefault
    ;
in {
  home-manager.users.alarsyo = {
    home.stateVersion = "23.11";

    my.home.laptop.enable = true;

    # Keyboard settings & i3 settings
    my.home.x.enable = true;
    my.home.x.i3bar.temperature.chip = "k10temp-pci-*";
    my.home.x.i3bar.temperature.inputs = ["Tctl"];
    my.home.x.i3bar.networking.throughput_interfaces = ["wlp1s0"];
    my.home.emacs.enable = true;

    my.theme = config.home-manager.users.alarsyo.my.themes.solarizedLight;

    # TODO: place in global home conf
    services.dunst.enable = true;

    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        ansel
        chromium # some websites only work there :(
        zotero
        ;

      inherit
        (pkgs.packages)
        spot
        ;
    };

    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        input = {
          "type:keyboard" = {
            xkb_layout = "fr";
            xkb_variant = "us";
          };
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            middle_emulation = "enabled";
            natural_scroll = "enabled";
          };
        };
        output = {
          "eDP-1" = {
            scale = "1.5";
          };
        };
        fonts = {
          names = ["Iosevka Fixed" "FontAwesome6Free"];
          size = 9.0;
        };
        bars = [];

        keybindings = mkOptionDefault {
          "Mod4+i" = "exec emacsclient --create-frame";
        };
        startup = [
          {command = "waybar";}
        ];
      };
    };
    programs = {
      fuzzel.enable = true;
      swaylock.enable = true;
      waybar = {
        enable = true;
      };
    };
  };
}
