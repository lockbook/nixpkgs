{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  glib,
  gobject-introspection,
  gdk-pixbuf,
  libxkbcommon,
  vulkan-loader,
  makeDesktopItem,
  copyDesktopItems,
}:
rustPlatform.buildRustPackage rec {
  pname = "lockbook-desktop";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    rev = "refs/tags/${version}";
    hash = "sha256-hqBjA/6MWlhVjV4m+cIcnoRTApHuzbPzivMsaQHfRcc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+M+wL26KDbLKhcujPyWAsTlXwLrQVCUbTnnu/7sXul4=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    gobject-introspection
    gdk-pixbuf
    libxkbcommon
    vulkan-loader
  ];

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook-linux"
  ];

  desktopItems = makeDesktopItem {
    desktopName = "Lockbook";
    name = "lockbook-desktop";
    comment = meta.description;
    icon = "lockbook";
    exec = "lockbook-desktop";
    categories = [
      "Office"
      "Documentation"
      "Utility"
    ];
  };

  postInstall = ''
    mv $out/bin/lockbook-linux $out/bin/lockbook-desktop
    install -D public_site/favicon.svg $out/share/icons/hicolor/scalable/apps/lockbook.svg
    patchelf --add-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/lockbook-desktop
  '';

  dontPatchELF = true;

  meta = {
    description = "Private, polished note-taking platform";
    longDescription = ''
      Write notes, sketch ideas, and store files in one secure place.
      Share seamlessly, keep data synced, and access it on any
      platform—even offline. Lockbook encrypts files so even we
      can’t see them, but don’t take our word for it:
      Lockbook is 100% open-source.
    '';
    homepage = "https://lockbook.net";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/lockbook/lockbook/releases";
    maintainers = [ lib.maintainers.parth ];
  };
}
