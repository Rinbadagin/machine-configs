{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    oneko
  ];

  systemd.user.services.oneko = {
    description = "Oneko server cat :3";

    wants = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      Environment = "WAYLAND_DISPLAY=wayland-0";
# Environment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/root/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
      ExecStart = "${pkgs.oneko}/bin/oneko";
      RemainAfterExit = true;
    };
  };
}

