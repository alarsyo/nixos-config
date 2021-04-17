{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
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
            nixpkgs.overlays = [ emacs-overlay.overlay ];
          }
        ];
    };
  };
}
