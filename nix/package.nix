{
  lib,
  stdenv,
  cmake,
  ninja,
  jdk17,
  zlib,
  qtbase,
  quazip,
  extra-cmake-modules,
  tomlplusplus,
  cmark,
  ghc_filesystem,
  gamemode,
  msaClientID ? null,
  gamemodeSupport ? true,
  self,
  version,
  libnbtplusplus,
}:
stdenv.mkDerivation rec {
  pname = "pollymc-unwrapped";
  inherit version;

  src = lib.cleanSource self;

  nativeBuildInputs = [extra-cmake-modules cmake jdk17 ninja];
  buildInputs =
    [
      qtbase
      zlib
      quazip
      ghc_filesystem
      tomlplusplus
      cmark
    ]
    ++ lib.optional gamemodeSupport gamemode;

  hardeningEnable = ["pie"];

  cmakeFlags =
    lib.optionals (msaClientID != null) ["-DLauncher_MSA_CLIENT_ID=${msaClientID}"]
    ++ lib.optionals (lib.versionOlder qtbase.version "6") ["-DLauncher_QT_VERSION_MAJOR=5"];

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/fn2006/PollyMC";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    changelog = "https://github.com/fn2006/PollyMC/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [fn2006];
  };
}
