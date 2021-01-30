final: prev:
{
  bitwarden_rs = prev.bitwarden_rs.overrideAttrs (drv: rec {
    version = "1.18.0";
    pname = "bitwarden_rs";
    name = "bitwarden_rs-${version}";

    src = prev.fetchFromGitHub {
      owner = "dani-garcia";
      repo = pname;
      rev = "1.18.0";
      sha256 = "sha256-iK0Yf5Hu76b4FXPTQsKIsyH69CQuLA9E/SoTaxC1U90=";
    };

    cargoDeps = drv.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;
      name = "${name}-vendor.tar.gz";

      outputHash = "sha256-LKLjZ4tti/MtloVQJ1C593FAcp0DDskIl5famT8wGuI=";
    });
  });
}
