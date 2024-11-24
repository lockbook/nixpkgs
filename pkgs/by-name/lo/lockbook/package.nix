{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "lockbook";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    rev = "0.9.15";
    hash = "sha256-hqBjA/6MWlhVjV4m+cIcnoRTApHuzbPzivMsaQHfRcc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "lb-fonts-0.1.5" = "sha256-WPUj+vn/E7uZrYvrpDonHQawEggKu+nvE0CVBPbDtyM=";
      "lb-pdf-0.2.3" = "sha256-1Fj1qGxtZnUIwH+x2XZTXYufc+ECcr5/P+6ERuc8PvU=";
      "minidom-0.15.3" = "sha256-V3Xy7r3eBheMlvVpGC/M/lTS7sM0C3L7ATRoeuM5c2A=";
    };
  };

  doCheck = false;
  cargoBuildFlags = [
    "--package"
    "lockbook-cli"
  ];

  # Optional: Declare metadata
  meta = with lib; {
    description = "CLI for Lockbook: Encrypted Notebook.";
    longDescription = "Write notes, sketch ideas, and store files in one secure place. Share seamlessly, keep data synced, and access it on any platform—even offline. Lockbook encrypts files so even we can’t see them, but don’t take our word for it: Lockbook is 100% open-source.";
    homepage = "https://lockbook.net";
    license = licenses.unlicense;
    platforms = platforms.all;
    changelog = "https://github.com/lockbook/lockbook/releases";
    maintainers = [ maintainers.parth ];
  };

  postInstall = ''
    # Generate and install shell completions
    mkdir -p $out/share/bash-completion/completions
    mkdir -p $out/share/zsh/site-functions
    mkdir -p $out/share/fish/vendor_completions.d

    # Generate the completion scripts
    $out/bin/lockbook completions bash > $out/share/bash-completion/completions/lockbook
    $out/bin/lockbook completions zsh > $out/share/zsh/site-functions/_lockbook
    $out/bin/lockbook completions fish > $out/share/fish/vendor_completions.d/lockbook.fish
  '';
}
