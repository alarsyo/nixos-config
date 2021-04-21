{ config, ... }:
{
  home-manager.users.alarsyo = {
    # Keyboard settings & i3 settings
    my.home.x.enable = true;
    my.home.emacs.enable = true;
    my.home.tmux.enable = true;
    my.theme = config.home-manager.users.alarsyo.my.themes.solarizedLight;
  };
}
