{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.pipewire;
  my = config.my;
in
{
  options.my.services.pipewire = {
    enable = lib.mkEnableOption "Pipewire sound backend";
  };

  config = mkIf cfg.enable {
    # from NixOS wiki, causes conflicts with pipewire
    sound.enable = false;
    # recommended for pipewire as well
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

      media-session = {
        enable = true;
        config.bluez-monitor.rules = [
          {
            # Matches all cards
            matches = [{ "device.name" = "~bluez_card.*"; }];
            actions = {
              "update-props" = {
                "bluez5.reconnect-profiles" = [
                  "a2dp_sink"
                  "hfp_hf"
                  "hsp_hs"
                ];
                # mSBC provides better audio + microphone
                "bluez5.msbc-support" = true;
                # SBC XQ provides better audio
                "bluez5.sbc-xq-support" = true;
              };
            };
          }
          {
            matches = [
              # Matches all sources
              {
                "node.name" = "~bluez_input.*";
              }
              # Matches all outputs
              {
                "node.name" = "~bluez_output.*";
              }
            ];
            actions = {
              "node.pause-on-idle" = false;
            };
          }
        ];
      };
    };
  };
}
