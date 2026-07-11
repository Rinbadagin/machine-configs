{ lib, ... }:
{
  # for MC
  networking.firewall.allowedTCPPorts = [ 25565 6666 25566 6969 ];

  # for Avocado
  users.users.avocado = {
    isNormalUser = true;
    openssh.authorizedKeys.keys =
    [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9S/RwneuxvHqLr+xEndd67m9pk/7lAaQ5PurQsiN+s avo@computercado"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6z5Jm443Z2MG2sJMSP71U/TQMshpsCe1LsCVVIAx+N avocado windows@DESKTOP-LMDC6DE"
    ];
  };
}
