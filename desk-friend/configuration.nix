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

  services.syncthing = {
    enable = true;
    # guiAddress = "0.0.0.0:8384";
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

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  services.flood = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };
  
  services.jellyfin = {
    enable = true;
    user = "klara";
    group = "klara";
    openFirewall = true;
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "localhost:8082,100.64.0.9:8082,desk-friend:8082";
    widgets = [
        {
            resources = {
              cpu = true;
              disk = "/";
              memory = true;
            };
        }
    ];
    services = [
        {
          "desk-friend utils" = [
            {
              "sonarr" = {
                description = "sonarr starr";
                href = "http://desk-friend:8989";
                widget = {
                  type = "sonarr";
                  url = "http://desk-friend:8989";
                  key = "cc583390c7e14e59ab9dcda8c77a5e45";
                };
              };
            }
            {
              "lidarr" = {
                description = "lidarr starr";
                href = "http://desk-friend:8686";
                widget = {
                  type = "lidarr";
                  url = "http://desk-friend:8686";
                  key = "04a705296c6a4d9ba2dc186c9774085d";
                };
              };
            }
            {
              "radarr" = {
                description = "radarr starr";
                href = "http://desk-friend:7878";
                widget = {
                  type = "radarr";
                  url = "http://desk-friend:7878";
                  key = "cb31b22e0fd64bd7b0cbf2fffa712136";
                };
              };
            }
            {
              "readarr" = {
                description = "readarr starr";
                href = "http://desk-friend:8787";
                widget = {
                  type = "readarr";
                  url = "http://desk-friend:8787";
                  key = "cb4fb2bae86b49779dc133f2444e9398";
                };
              };
            }
            {
              "flood" = {
                description = "flood! aah!";
                href = "http://desk-friend:3000";
                widget = {
                  type = "flood";
                  url = "http://desk-friend:3000";
                };
              };
              
            }
          ];
        }
    ];
  };

  users.users.lidarr = {
    extraGroups = [ "qbittorrent" ];
  };

  users.users.sonarr = {
    extraGroups = [ "qbittorrent" ];
  };

  users.users.radarr = {
    extraGroups = [ "qbittorrent" ];
  };

  users.users.readarr = {
    extraGroups = [ "qbittorrent" ];
  };

  users.users.jellyfin = {
    extraGroups = [ "qbittorrent" ];
  };

  system.stateVersion = "25.05";
}
