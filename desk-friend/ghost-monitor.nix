{ config, lib, pkgs, ... }:
{
  # Also referenced in the configuration of desk-friend
  # Should really be in its own dir/part of base and selectively included
  # Any changes should be checked there too
    services.desktopManager.plasma6.enable = true;
  
    services.displayManager = {
        defaultSession = "plasmax11";
        autoLogin.enable = true;
        autoLogin.user = "klara";
    };

  services.xserver = {
        enable = true;

        xkb = {
        layout = "nz";
        variant = "";
        };
        
#        displayManager.startx.enable = true;
        # Dummy screen
        monitorSection = ''
            VendorName     "Unknown"
            HorizSync   30-85
            VertRefresh 48-120

                ModeLine        "1920x1080" 148.35  1920 2008 2052 2200 1080 1084 1089 1125
            ModelName      "Unknown"
            Option         "DPMS"
        '';

        deviceSection = ''
            VendorName "NotAReal Corporation"
            Option      "AllowEmptyInitialConfiguration"
            Option      "ConnectedMonitor" "Screen 0"
            Option      "CustomEDID" "DFP-0"

        '';

        screenSection = ''
            DefaultDepth    24
            Option      "ModeValidation" "AllowNonEdidModes, NoVesaModes"
            Option      "MetaModes" "1920x1080"
            SubSection     "Display"
                Depth       24
            EndSubSection
        '';
    };

    security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${ pkgs.sunshine }/bin/sunshine";
    };

    # Inspired from https://github.com/LizardByte/Sunshine/blob/5bca024899eff8f50e04c1723aeca25fc5e542ca/packaging/linux/sunshine.service.in
    systemd.user.services.sunshine = {
        description = "Sunshine server";
        wantedBy = [ "graphical-session.target" ];
        startLimitIntervalSec = 500;
        startLimitBurst = 5;
        partOf = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        unitConfig.ConditionUser = "klara";

        serviceConfig = let
          sunshineConfigFile = pkgs.writeTextDir "config/sunshine.conf"
          ''
          origin_web_ui_allowed=wan
          origin_pin_allowed = "wan"
          wan_encryption_mode = 0
          lan_encryption_mode = 0
          csrf_allowed_origins = https://localhost, https://desk-friend, https://localhost, https://127.0.0.1, https://[::1]
          ''; in {
            ExecStart = "${config.security.wrapperDir}/sunshine ${sunshineConfigFile}/config/sunshine.conf";
            Restart = "on-failure";
            RestartSec = "5s";
        };
    };
    
    services.avahi.publish.userServices = true;

}