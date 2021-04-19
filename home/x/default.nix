{ config, lib, pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./i3bar.nix
  ];

  options.my.home.x = with lib; {
    enable = mkEnableOption "X server configuration";
  };
}
