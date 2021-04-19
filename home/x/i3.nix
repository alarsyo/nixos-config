{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.x.enable;

  myTerminal =
    # FIXME: fix when terminal is setup in home
    # if config.my.home.terminal.program != null
    if true
    then "alacritty"
    else "i3-sensible-terminal";

  alt = "Mod1"; # `Alt` key
  modifier = "Mod4"; # `Super` key

  logoutMode = "[L]ogout, [S]uspend, [P]oweroff, [R]eboot";
in
{
  config = lib.mkIf isEnabled {
    # FIXME: enable flameshot when added
    # my.home = {};

    xsession.windowManager.i3 = {
      enable = true;

      config = {
        inherit modifier;

        bars =
          [
            {
              statusCommand = "i3status";
              position = "top";
            }
          ];

        focus = {
          followMouse = true;
          mouseWarping = true;
        };

        fonts = [
          "DejaVu Sans Mono 8"
        ];

        keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+e" = ''mode "${logoutMode}"'';
        };

        modes =
          let
            makeModeBindings = attrs: attrs // {
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          in
          {
            ${logoutMode} = makeModeBindings {
              "l" = "exec --no-startup-id i3-msg exit, mode default";
              "s" = "exec --no-startup-id systemctl suspend, mode default";
              "p" = "exec --no-startup-id systemctl poweroff, mode default";
              "r" = "exec --no-startup-id systemctl reboot, mode default";
            };
          };

        startup = [
          # FIXME: make it conditional on "nvidia" being part of video drivers
          {
            command = "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'";
            notification = false;
          }
        ];

        terminal = myTerminal;
      };
    };
  };
}
