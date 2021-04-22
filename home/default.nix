{ ... }:
{
  imports = [
    ./alacritty.nix
    ./emacs.nix
    ./fish
    ./flameshot.nix
    ./secrets
    ./starship.nix
    ./themes
    ./tmux.nix
    ./x
  ];

  home.stateVersion = "20.09";

  home.username = "alarsyo";
}
