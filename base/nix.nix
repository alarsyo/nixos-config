{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    binaryCaches = [
      "https://alarsyo.cachix.org"
    ];
    binaryCachePublicKeys = [
      "alarsyo.cachix.org-1:A6BmcaJek5+ZDWWv3fPteHhPm6U8liS9CbDbmegPfmk="
    ];

    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 30d";
    };
  };
}
