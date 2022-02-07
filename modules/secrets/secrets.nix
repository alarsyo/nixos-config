let
  alarsyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3rrF3VSWI4n4cpguvlmLAaU3uftuX4AVV/39S/8GO9 alarsyo@thinkpad";
  users = [ alarsyo ];

  boreal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAagal1aqZh52wEmgsw7fkCzO41o4Cx+nV4wJGZuX1RP root@boreal";
  poseidon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYhZYMbWQG9TSQ2qze8GgFo2XrZzgu/GuSOGwenByJo root@poseidon";
  zephyrus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU4JfIADH9MXUnVe+3ezYK9WXsqy/jJcm1zFkmL4aSU root@zephyrus";

  machines = [ boreal poseidon zephyrus ];

  all = users ++ machines;
in
{
  "restic-backup/boreal-password.age".publicKeys = [ alarsyo boreal ];
  "restic-backup/boreal-credentials.age".publicKeys = [ alarsyo boreal ];
  "restic-backup/zephyrus-password.age".publicKeys = [ alarsyo zephyrus ];
  "restic-backup/zephyrus-credentials.age".publicKeys = [ alarsyo zephyrus ];

  "users/root-hashed-password.age".publicKeys = machines;
  "users/alarsyo-hashed-password.age".publicKeys = machines ++ [ alarsyo ];
}