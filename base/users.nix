{ config, lib, pkgs, ... }:
{
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = lib.fileContents ../secrets/shadow-hashed-password-root;
  };
  users.users.alarsyo = {
    hashedPassword = lib.fileContents ../secrets/shadow-hashed-password-alarsyo;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3rrF3VSWI4n4cpguvlmLAaU3uftuX4AVV/39S/8GO9 alarsyo@thinkpad"
    ];
  };
}
