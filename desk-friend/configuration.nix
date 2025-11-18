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

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.age.secrets."k3s-server-token.age".path;
    serverAddr = "https://dusty-cobweb:6443";
  };

  system.stateVersion = "25.05";
}
