{ ... }:
{
  imports = [
    ./emacs.nix
    ./flameshot.nix
    ./tmux.nix
    ./x
  ];

  home.stateVersion = "20.09";

  home.username = "alarsyo";
}
