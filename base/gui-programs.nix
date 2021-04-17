{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    feh
    firefox
    flameshot
    pavucontrol
    slack
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
}
