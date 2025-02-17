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
        hyprlock
        nwg-displays
        shikane # output autoconfig
        zotero
        ;

      inherit
        (pkgs.packages)
        spot
        ;
    };

    wayland.windowManager.sway = let
      logoutMode = "[L]ogout, [S]uspend, [P]oweroff, [R]eboot";
    in {
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
          size = 8.0;
        };
        bars = [];

        keybindings = mkOptionDefault {
          "Mod4+Shift+e" = ''mode "${logoutMode}"'';
          "Mod4+i" = "exec emacsclient --create-frame";
          "Mod4+Control+l" = "exec hyprlock";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2";
          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";
        };

        modes = mkOptionDefault {
          "${logoutMode}" = {
            "l" = "exec --no-startup-id swaymsg exit, mode default";
            #"s" = "exec --no-startup-id betterlockscreen --suspend, mode default";
            "p" = "exec --no-startup-id systemctl poweroff, mode default";
            "r" = "exec --no-startup-id systemctl reboot, mode default";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };

        menu = "fuzzel --list-executables-in-path";

        startup = [
          {command = "shikane";}
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
