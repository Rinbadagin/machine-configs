# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  modulesPath,
    lib,
    pkgs,
    config,
    ...
} @ args:
{
  imports =
    [ # Include the results of the hardware scan.
    # ./hardware-configuration.nix
      ./power-configuration.nix
      ./package-configuration.nix
      ./user-configuration.nix
      ./home-configuration.nix
      ./modules/smb-client.nix
      ./boot/plymouth.nix
    #  "${(builtins.fetchTarball { 
    #     url = "https://github.com/ryantm/agenix/archive/main.tar.gz";
    #     sha256 = "sha256-Ks+p8geHkzSc2z51GOiugLDqxy8lgNhF/2o3Pc/a9VU=";
    #   })}/modules/age.nix" 
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "libcomposite" "usb_f_hid" ];

  security.polkit.enable = true;

   systemd = {
     user.services.polkit-gnome-authentication-agent-1 = {
       description = "polkit-gnome-authentication-agent-1";
       wantedBy = [ "graphical-session.target" ];
       wants = [ "graphical-session.target" ];
       after = [ "graphical-session.target" ];
       serviceConfig = {
           Type = "simple";
           ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
           Restart = "on-failure";
           RestartSec = 1;
           TimeoutStopSec = 10;
         };
     };
   };

   networking.hostName = "the-machine"; # Define your hostname.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

 # Configure network proxy if necessary
 # networking.proxy.default = "http://user:password@proxy:port/";
 # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

 # Enable networking
     # networking.networkmanager.enable = true;
     networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

     networking = {
       interfaces.enp1s0 = {
       ipv6.addresses = [{
         address = "2a01:4f8:1c1b:16d0::1";
         prefixLength = 64;
       }];
       ipv4.addresses = [{
         address = "192.0.2.2";
         prefixLength = 24;
       }];
       };
     };

 # Set your time zone.
   time.timeZone = "Pacific/Auckland";

 # Select internationalisation properties.
   i18n.defaultLocale = "en_NZ.UTF-8";

   i18n.supportedLocales = [ "all"];

   i18n.extraLocaleSettings = {
     LC_ADDRESS = "en_NZ.UTF-8";
     LC_IDENTIFICATION = "en_NZ.UTF-8";
     LC_MEASUREMENT = "en_NZ.UTF-8";
     LC_MONETARY = "en_NZ.UTF-8";
     LC_NAME = "en_NZ.UTF-8";
     LC_NUMERIC = "en_NZ.UTF-8";
     LC_PAPER = "en_NZ.UTF-8";
     LC_TELEPHONE = "en_NZ.UTF-8";
     LC_TIME = "en_NZ.UTF-8";
   };

 # Enable the X11 windowing system.
   services.xserver.enable = true;

   services.xserver.wacom.enable = true;
   # services.syncthing.user = "klara";
   services.syncthing = {
     enable = true;
     group = "users";
     user = "klara";
     dataDir = "/home/klara/synced";
     configDir = "/home/klara/.config/syncthing";
   };

 # Enable the GNOME Desktop Environment

 # Configure keymap in X11
   services.xserver.xkb = {
     layout = "nz,de";
     variant = "";
     options = "caps:ctrl_modifier";
   };

   # services.dnsmasq.enable = true;

   services.gnome.gnome-keyring.enable = true;

   programs.sway = {
     enable = true;
     package = pkgs.swayfx;
     wrapperFeatures.gtk = true;
   };

   virtualisation.containers.enable = true;
   #virtualisation = {
   # podman = {
   #  docker = {
   #    enable = true;

       # Create a `docker` alias for podman, to use it as a drop-in replacement
       # dockerCompat = true;

       # Required for containers under podman-compose to be able to talk to each other.
       # defaultNetwork.settings.dns_enabled = true;
   #  };
   # };

   services.greetd = {                                                      
     enable = true;                                                         
     settings = {                                                           
       default_session = {                                                  
         command = 
         #  let art = "\"
         #  ${ builtins.readFile "./boot/login-prompt" }
         #  \""; 
         # in 
"${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'hello' --greet-align left
           --time --cmd 'dbus-run-session sway'";
         user = "greeter";                                                  
       };                                                                   
     };                                                                     
   };

 # Enable CUPS to print documents.
   services.printing.enable = true;

 # Enable sound with pipewire.
   services.pulseaudio.enable = false;
   security.rtkit.enable = true;
   security.sudo.wheelNeedsPassword = false;
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
 # If you want to use JACK applications, uncomment this
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
 
 #jack.enable = true;

 # use the example session manager (no others are packaged yet so this is enabled by default,
 # no need to redefine it in your config for now)
 #media-session.enable = true;
   };

 # Enable touchpad support (enabled default in most desktopManager).
 # services.xserver.libinput.enable = true;


 # Install firefox.
   programs.firefox.enable = true;

 # Allow unfree packages
   nixpkgs.config.allowUnfree = true;

   nix.settings.trusted-users = [ "root" "klara" ];

 # Some programs need SUID wrappers, can be configured further or are
 # started in user sessions.
 # programs.mtr.enable = true;
 # programs.gnupg.agent = {
 #   enable = true;
 #   enableSSHSupport = true;
 # };

 # List services that you want to enable:

 # Enable the OpenSSH daemon.
 # services.openssh.enable = true;

 # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 43594 1701 8000 8765 48000 48010 47990 ];
   networking.firewall.allowedUDPPorts = [ 43594 9001 8000 8765 48000 48010 47990 ];

   networking.firewall.enable = false;

   age.secrets = let
     secrets = import ./secrets/secrets.nix;
   in
     builtins.mapAttrs (name: attrs: {
       file = ./secrets/${name};
       owner = attrs.owner or "root";
       group = attrs.group or "root";
       mode = attrs.mode or "0400";
     }) secrets;

   services.openssh = {
     enable = true;
     settings = {
       PasswordAuthentication = false;
       KbdInteractiveAuthentication = false;
       # PermitRootLogin = "no";
       AllowUsers = [ "klara" ];
     };
   };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
