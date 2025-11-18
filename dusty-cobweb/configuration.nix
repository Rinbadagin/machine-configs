{
  modulesPath,
    lib,
    pkgs,
    config,
    ...
} @ args:
{
  imports = [
    ./disk-config.nix
  ];

  networking = {
    hostName = "dusty-cobweb";
  };


  system.stateVersion = "25.05";
}
