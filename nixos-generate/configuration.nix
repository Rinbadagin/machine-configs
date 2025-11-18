{ pkgs, modulesPath, lib, ... }: {

  imports = [

    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

  ];


  # use the latest Linux kernel

  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Needed for https://github.com/NixOS/nixpkgs/issues/58959

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  networking.wireless = {
    enable = true;
    networks = {
      disconet = {
        #ssid="disconet";
        #psk="disconet"
        pskRaw = "1bfc343772e8153034c0d253b288835881c347eba1492627490abeb425f02c7d";
      };
    };
  };

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  programs.zsh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPurq4HYYHK0nxukQQAXm9mxlJ2/3plx79z0ckP3q/Q"
  ];
}
