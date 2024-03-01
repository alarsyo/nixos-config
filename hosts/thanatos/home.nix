{config, ...}: {
  home-manager.users.alarsyo = {
    # TODO: can probably upgrade me
    home.stateVersion = "21.05";

    my.theme = config.home-manager.users.alarsyo.my.themes.solarizedLight;
  };
}
