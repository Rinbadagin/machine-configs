{
  modulesPath,
    lib,
    pkgs,
    config,
    ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./disk-config.nix
  ];

  networking = {
    hostName = "desk-friend";
  };


  system.stateVersion = "25.05";
}
