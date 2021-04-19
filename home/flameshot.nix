{ config, lib, ... }:
let
  cfg = config.my.home.flameshot;
in
{
  options.my.home.flameshot = with lib; {
    enable = mkEnableOption "flameshot autolaunch";
  };

  config.services.flameshot = lib.mkIf cfg.enable {
    enable = true;
  };
}
