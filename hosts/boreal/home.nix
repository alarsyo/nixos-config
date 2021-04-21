{ config, ... }:
{
  home-manager.users.alarsyo = {
    # Keyboard settings & i3 settings
    my.home.x.enable = true;
    my.home.emacs.enable = true;
    my.home.tmux.enable = true;
    my.home.theme = config.home-manager.users.alarsyo.my.home.themes.solarizedLight;
  };
}
