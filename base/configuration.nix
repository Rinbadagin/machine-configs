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
  ];
  boot.loader.grub = {
# no need to set devices, disko will add all devices that have a EF02 partition to the list already
# devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  age.secrets = let
    secrets = import ./secrets/secrets.nix;
  in
    builtins.mapAttrs (name: attrs: {
        file = ./secrets/${name};
        owner = attrs.owner or "root";
        group = attrs.group or "root";
        mode = attrs.mode or "0400";
        }) secrets;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.fastfetch
    pkgs.nfs-utils
    pkgs.ncdu
    pkgs.powertop
    pkgs.htop
    pkgs.vim
    pkgs.tmux
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    histSize = 1000000;
    shellAliases = {
      rebuild = "cd ~/machine-configs && git pull && sudo nixos-rebuild switch --flake \".#$(hostname)\"";
    };
    ohMyZsh= {
      enable = true;
      theme = "agnoster";
      plugins = [ "aliases" "git" "colorize" ];
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 5d"; 

  users.defaultUserShell = pkgs.zsh;

  users.users.klara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nix.extraOptions = ''
    trusted-users = root klara
    '';

  users.users.root.openssh.authorizedKeys.keys =
    [
# change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPurq4HYYHK0nxukQQAXm9mxlJ2/3plx79z0ckP3q/Q"
    ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  services.openssh = {
    enable = true;
# require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
    settings.GatewayPorts = "yes";
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets."tailscale-authkey.age".path;
#    authKeyParameters.preauthorized = true;
    extraUpFlags = [ "--login-server" "https://hs.fem.nz/" ];
  };

  networking = {
    wireless = {
      enable = true;
      networks = {
        disconet = {
	  # ssid = "disconet";
          pskRaw = "1bfc343772e8153034c0d253b288835881c347eba1492627490abeb425f02c7d";
        };
	"lesbians lounge" = {
	  # ssid = "lesbians lounge"
          pskRaw = "e058b96640d62dda6a3dbce578f0b0ad56a9696f1586c11bb3d5e5b6a1152fe7";
	};
      };
    };
  };

  # FROM: https://wiki.nixos.org/wiki/Prometheus
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
  # services.prometheus.exporters.node = {
  #   enable = true;
  #   port = 9000;
  #   # For the list of available collectors, run, depending on your install:
  #   # - Flake-based: nix run nixpkgs#prometheus-node-exporter -- --help
  #   # - Classic: nix-shell -p prometheus-node-exporter --run "node_exporter --help"
    
  #   enabledCollectors = [
  #     "ethtool"   
  #     "softirqs"
  #     "systemd"
  #     "tcpstat"
  #     "diskstats"
  #     "cpu"
  #   ];

  #   # You can pass extra options to the exporter using `extraFlags`, e.g.
  #   # to configure collectors or disable those enabled by default.
  #   # Enabling a collector is also possible using "--collector.[name]",
  #   # but is otherwise equivalent to using `enabledCollectors` above.
  #   extraFlags = [ "--collector.ntp.protocol-version=4" "--no-collector.mdadm" ];
  # };

  system.stateVersion = "25.05";
}
