{ config, ... }:
{
  home-manager.users.alarsyo = {
    my.home.fish.enable = true;

    my.theme = config.home-manager.users.alarsyo.my.themes.solarizedLight;
  };
}
