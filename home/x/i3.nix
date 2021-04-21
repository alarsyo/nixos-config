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

  i3Theme = config.my.theme.i3Theme;
in
{
  config = lib.mkIf isEnabled {
    my.home = {
      flameshot.enable = true;
    };

    home.packages = with pkgs; [
      betterlockscreen
    ];

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
              fonts = [ "DejaVuSansMono" "FontAwesome5Free 9" ];

              colors = i3Theme.bar;
            }
          ];

        colors = {
          inherit (i3Theme)
            focused
            focusedInactive
            unfocused
            urgent
          ;
        };

        focus = {
          followMouse = true;
          mouseWarping = true;
        };

        fonts = [
          "DejaVu Sans Mono 8"
        ];

        keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+e" = ''mode "${logoutMode}"'';
          "${modifier}+i" = "exec emacsclient -c";

          # Volume handling
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          "${modifier}+l" = "exec --no-startup-id betterlockscreen --lock";
        };

        modes =
          let
            makeModeBindings = attrs: attrs // {
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          in
            lib.mkOptionDefault {
              "${logoutMode}" = makeModeBindings {
                "l" = "exec --no-startup-id i3-msg exit, mode default";
                "s" = "exec --no-startup-id betterlockscreen --suspend, mode default";
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

        assigns = {
          "10" = [
            { class = "Slack"; }
          ];
        };
      };

      extraConfig = ''
        workspace_auto_back_and_forth yes
      '';
    };
  };
}
