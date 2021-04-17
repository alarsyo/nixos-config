{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    firefox
    flameshot
    slack
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
}
