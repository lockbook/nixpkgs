{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.ecryptfs;

in
{
  options.programs.ecryptfs = {
    enable = lib.mkEnableOption "ecryptfs setuid mount wrappers";
  };

  config = lib.mkIf cfg.enable {
    security.wrappers = {

      "mount.ecryptfs_private" = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.ecryptfs}/bin/mount.ecryptfs_private";
      };
      "umount.ecryptfs_private" = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.ecryptfs}/bin/umount.ecryptfs_private";
      };

    };
  };
}
