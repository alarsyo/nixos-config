{ ... }:
{
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./emacs.nix
    ./env.nix
    ./fish
    ./flameshot.nix
    ./git.nix
    ./laptop.nix
    ./rofi.nix
    ./secrets
    ./ssh.nix
    ./starship.nix
    ./themes
    ./tmux.nix
    ./x
  ];

  home.stateVersion = "21.05";

  home.username = "alarsyo";
}
