{ config, lib, pkgs, ... }:
{
  imports = [
    ./i3.nix
  ];

  options.my.home.x = with lib; {
    enable = mkEnableOption "X server configuration";
  };
}
