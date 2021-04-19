{ pkgs, lib, rustPlatform, fetchFromGitHub }:
let
  pname = "tmux-thumbs";
  version = "0.5.1";
  tmux-thumbs-binary = rustPlatform.buildRustPackage {
    pname = pname;
    version = version;

    src = fetchFromGitHub {
      owner = "fcsonline";
      repo = pname;
      rev = version;
      sha256 = "sha256-rU+tsrYJxoqF8Odh2ucvNekc+fLnSY6kFoVFUjqaTFE=";
    };

    cargoSha256 = "sha256-/F9tftRLqC6dk7lX41C8RUMqlrgzc0nkunc0rue5zuM=";

    patches = [ ./fix.patch ];
    postPatch = ''
      substituteInPlace src/swapper.rs --replace '@@replace-me@@' '$out/bin/thumbs'
    '';
    meta = {};
  };
in pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = pname;
  version = version;
  rtpFilePath = "tmux-thumbs.tmux";
  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-rU+tsrYJxoqF8Odh2ucvNekc+fLnSY6kFoVFUjqaTFE=";
  };
  patches = [ ./fix.patch ];
  postInstall = ''
    substituteInPlace $target/tmux-thumbs.sh --replace '@@replace-me@@' '${tmux-thumbs-binary}/bin/tmux-thumbs'
  '';
}
