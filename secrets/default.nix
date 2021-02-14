{ lib, config, ... }:
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
  };
}
