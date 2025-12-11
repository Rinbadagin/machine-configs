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
    nameservers = [ "9.9.9.9" "8.8.8.8" ];
  };

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.age.secrets."k3s-server-token.age".path;
    serverAddr = "https://dusty-cobweb:6443";
  };

  services.lidarr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };

  services.radarr = {
    enable = true;
  };
  
  services.readarr = {
    enable = true;
    # settings could be populated automatically with public metadata instance here
    # instance/settings/development setting 'Metadata Provider Source' to https://api.bookinfo.pro/
    # https://github.com/blampe/rreading-glasses?tab=readme-ov-file
  };

  services.prowlarr = {
    enable = true;
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    openRPCPort = true;
    settings.rpc-bind-address = "0.0.0.0";
  };

  services.flood = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  users.users.lidarr = {
    extraGroups = [ "transmission" ];
  };

  users.users.sonarr = {
    extraGroups = [ "transmission" ];
  };

  users.users.radarr = {
    extraGroups = [ "transmission" ];
  };

  users.users.readarr = {
    extraGroups = [ "transmission" ];
  };

  system.stateVersion = "25.05";
}
