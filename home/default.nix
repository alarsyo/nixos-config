{ ... }:
{
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./emacs.nix
    ./env.nix
    ./fish
    ./flameshot.nix
    ./laptop.nix
    ./secrets
    ./starship.nix
    ./themes
    ./tmux.nix
    ./x
  ];

  home.stateVersion = "21.05";

  home.username = "alarsyo";
}
