{ ... }:
{
  imports = [
    ./emacs.nix
    ./x
  ];

  home.stateVersion = "20.09";

  home.username = "alarsyo";
}
