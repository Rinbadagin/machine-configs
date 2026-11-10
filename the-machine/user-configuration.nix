{ config, pkgs, ...}:
{
  users.users.klara = {
    isNormalUser = true;
    description = "Klara";
    extraGroups = [ "wpa_supplicant" "wheel" "docker" "syncthing" "plugdev" "dialout" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
# Managed by home-manager - do we need this?
    ];
  };
}
