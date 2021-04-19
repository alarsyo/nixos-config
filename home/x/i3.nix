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

  # colors
  colorBg = "#282828";
  colorRed = "#cc241d";
  colorGreen = "#98971a";
  colorYellow = "#d79921";
  colorBlue = "#458588";
  colorPurple = "#b16286";
  colorAqua = "#689d68";
  colorGray = "#a89984";
  colorDarkGray = "#1d2021";
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
          let
            barConfigPath =
              config.xdg.configFile."i3status-rust/config-top.toml".target;
          in
          [
            {
              statusCommand = "i3status-rs ${barConfigPath}";
              position = "top";

              colors = {
                background = colorBg;
                statusline = colorYellow;

                focusedWorkspace = {
                  border = colorAqua;
                  background = colorAqua;
                  text = colorDarkGray;
                };
                inactiveWorkspace = {
                  border = colorDarkGray;
                  background = colorDarkGray;
                  text = colorYellow;
                };
                activeWorkspace = {
                  border = colorAqua;
                  background = colorDarkGray;
                  text = colorYellow;
                };
                urgentWorkspace = {
                  border = colorRed;
                  background = colorRed;
                  text = colorBg;
                };
              };
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
          "${modifier}+i" = "exec ${pkgs.emacsPgtkGcc}/bin/emacsclient -c";
        };

        modes =
          let
            makeModeBindings = attrs: attrs // {
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          in
          {
            "${logoutMode}" = makeModeBindings {
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
