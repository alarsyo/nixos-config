final: prev:
{
  bitwarden_rs-vault = prev.bitwarden_rs-vault.overrideAttrs (drv: rec {
    version = "2.17.1";

    src = prev.fetchurl {
      url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
      sha256 = "1kd21higniszk1na5ag7q4g0l7h6ddl91gpbjbwym28hsbjvxla7";
    };
  });
}
