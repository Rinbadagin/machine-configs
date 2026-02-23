{ lib, ... }:
{
  # for MC
  networking.firewall.allowedTCPPorts = [ 25565 ];

  # for Avocado
  users.users.avocado = {
    isNormalUser = true;
    openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9S/RwneuxvHqLr+xEndd67m9pk/7lAaQ5PurQsiN+s avo@computercado" ];
  };
}