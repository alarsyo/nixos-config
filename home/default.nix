{ ... }:
{
  imports = [
    ./alacritty.nix
    ./emacs.nix
    ./flameshot.nix
    ./secrets
    ./themes
    ./tmux.nix
    ./x
  ];

  home.stateVersion = "20.09";

  home.username = "alarsyo";
}
