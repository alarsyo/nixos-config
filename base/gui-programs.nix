{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    firefox
    flameshot
    pavucontrol
    slack
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
}
