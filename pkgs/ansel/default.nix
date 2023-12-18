{
  cmake,
  colord,
  colord-gtk,
  curl,
  dav1d,
  desktop-file-utils,
  exiftool,
  exiv2,
  fetchFromGitHub,
  glib,
  gmic,
  graphicsmagick,
  gtk3,
  icu,
  intltool,
  isocodes,
  jasper,
  json-glib,
  lcms,
  lensfun,
  lib,
  libXdmcp,
  libXtst,
  libaom,
  libavif,
  libdatrie,
  libde265,
  libepoxy,
  libffi,
  libgcrypt,
  libgpg-error,
  libheif,
  libjpeg,
  libpsl,
  librsvg,
  libsecret,
  libselinux,
  libsepol,
  libsoup,
  libsysprof-capture,
  libthai,
  libwebp,
  libxkbcommon,
  libxml2,
  libxslt,
  llvmPackages,
  openexr_3,
  openjpeg,
  osm-gps-map,
  pcre,
  pcre2,
  perlPackages,
  pkg-config,
  pugixml,
  python3Packages,
  rav1e,
  sqlite,
  stdenv,
  util-linux,
  wrapGAppsHook,
  x265,
}:
stdenv.mkDerivation {
  pname = "ansel";
  version = "unstable-2023-12-15";

  src = fetchFromGitHub {
    owner = "aurelienpierreeng";
    repo = "ansel";
    rev = "53c609cd274b6b893ed10214ac6877941d1b486b";
    hash = "sha256-ed3rKdJRO+QQdn+C4DANoztXxtoMvHudBvJQogoaHT0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    exiftool
    intltool
    libxml2
    llvmPackages.clang
    llvmPackages.llvm
    pkg-config
    perlPackages.perl
    python3Packages.jsonschema
    wrapGAppsHook
  ];

  buildInputs = [
    colord
    colord-gtk
    curl
    dav1d
    exiv2
    json-glib
    glib
    gmic
    graphicsmagick
    gtk3
    icu
    isocodes
    jasper
    lcms
    lensfun
    libaom
    libavif
    libdatrie
    libde265
    libepoxy
    libffi
    libgcrypt
    libgpg-error
    libheif
    libjpeg
    libpsl
    librsvg
    libsecret
    libselinux
    libsepol
    libsoup
    libsysprof-capture
    libthai
    libwebp
    libXdmcp
    libxkbcommon
    libxslt
    libXtst
    openexr_3
    openjpeg
    osm-gps-map
    pcre
    pcre2
    perlPackages.Po4a
    pugixml
    rav1e
    sqlite
    util-linux
    x265
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ":" "$out/lib/ansel"
    )
  '';

  meta = {
    description = "A darktable fork minus the bloat plus some design vision";
    homepage = "https://ansel.photos/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ansel";
    platforms = lib.platforms.linux;
  };
}
