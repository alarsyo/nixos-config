{ ... }:
{
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./emacs.nix
    ./env.nix
    ./firefox.nix
    ./fish
    ./flameshot.nix
    ./git.nix
    ./laptop.nix
    ./lorri.nix
    ./rofi.nix
    ./ssh.nix
    ./themes
    ./tmux.nix
    ./tridactyl.nix
    ./x
  ];

  home.stateVersion = "21.05";

  home.username = "alarsyo";
}
