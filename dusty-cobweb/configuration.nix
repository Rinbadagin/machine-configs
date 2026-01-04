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

    firewall = {
      # from https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
      # for k3s inbound, 6443
      allowedTCPPorts = [ 443 80 ];
    };
  };

  #services.k3s = {
  #  enable = true;
  #  role = "server";
  #  tokenFile = config.age.secrets."k3s-server-token.age".path;
  #};

  services.caddy = {
    enable = true;
    virtualHosts = {
      "demo.klara.nz" = {
        extraConfig = ''
          encode gzip
          root * /srv/http
          file_server
        '';
      };
    };
  };


  system.stateVersion = "25.05";
}
