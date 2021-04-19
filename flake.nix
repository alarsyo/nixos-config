{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-20.09";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, emacs-overlay }: {
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        [
          ./poseidon.nix

          {
            nixpkgs.overlays =
              let
                pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
              in
                [
                  # packages accessible through pkgs.unstable.package
                  (final: prev: {
                    unstable = pkgsUnstable;
                  })
                  (final: prev: {
                    bitwarden_rs = pkgsUnstable.bitwarden_rs;
                    bitwarden_rs-vault = pkgsUnstable.bitwarden_rs-vault;
                  })
                ];
          }
        ];
    };
    nixosConfigurations.boreal = nixpkgs-unstable.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        [
          ./boreal.nix

          {
            nixpkgs.overlays = [
              emacs-overlay.overlay

              # uncomment this to build everything from scratch, fun but takes a
              # while
              #
              # (self: super: {
              #   stdenv = super.impureUseNativeOptimizations super.stdenv;
              # })
            ];
          }
        ];
    };
  };
}
