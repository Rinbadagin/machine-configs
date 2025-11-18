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
      pkgs.neofetch
  ];

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
#ssid="disconet";
          pskRaw = "1bfc343772e8153034c0d253b288835881c347eba1492627490abeb425f02c7d";
        };
        Homelander = {
# generated with wpa_passphrase <ssid> <psk>
# ssid="Homelander"
          pskRaw = "2d4cd2ce56c462533ce0cd8a1b44502db2c94212ce106795724efbeea9a6c002";
        };
      };
    };
  };


  system.stateVersion = "25.05";
}
