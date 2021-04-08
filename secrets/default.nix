{ pkgs, lib, config, ... }:
with lib;
{
  options.my.secrets = mkOption {
    type = types.attrs;
  };

  config.my.secrets = {
    matrix-registration-shared-secret = lib.fileContents ./matrix-registration-shared-secret.secret;
    shadow-hashed-password-alarsyo = lib.fileContents ./shadow-hashed-password-alarsyo.secret;
    shadow-hashed-password-root = lib.fileContents ./shadow-hashed-password-root.secret;
    miniflux-admin-credentials = lib.fileContents ./miniflux-admin-credentials.secret;
    borg-backup-repo = lib.fileContents ./borg-backup-repo.secret;
    transmission-password = lib.fileContents ./transmission.secret;
    nextcloud-admin-pass = lib.fileContents ./nextcloud-admin-pass.secret;
    nextcloud-admin-user = lib.fileContents ./nextcloud-admin-user.secret;
    lohr-shared-secret = lib.fileContents ./lohr-shared-secret.secret;

    wireguard = pkgs.callPackage ./wireguard.nix { };
  };
}
