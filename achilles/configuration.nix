#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
# Home manager
      (import "${(builtins.fetchTarball {
  url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
  sha256 = "0h5mdxblkvipnsj5b68gshl92d9b0b03nlib3mrgipl1mh05xxjn";
  })}/nixos")
    ];
  system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?

  fileSystems."/speedy" = {
    device = "/dev/disk/by-uuid/2aa8a487-cc03-4c60-ac7a-3442ad0ca917";
    fsType = "ext4";
  };

  networking = {
  interfaces.enp5s0 = {
    ipv6.addresses = [{
      address = "2a01:4f8:1c1b:16d0::2";
      prefixLength = 64;
    }];
    ipv4.addresses = [{
      address = "192.0.2.3";
      prefixLength = 24;
    }];
    };
  };

  services.lidarr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
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
    allowedHosts = "localhost:8082,100.64.0.9:8082,achilles:8082";
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
                href = "http://achilles:8989";
                widget = {
                  type = "sonarr";
                  url = "http://achilles:8989";
                  key = "bf18fbf0f6e4474fb668ac8c4d50303d";
                };
              };
            }
            {
              "lidarr" = {
                description = "lidarr starr";
                href = "http://achilles:8686";
                widget = {
                  type = "lidarr";
                  url = "http://achilles:8686";
                  key = "f33a7d37fd4c48b497e02e4f9ac36b3c";
                };
              };
            }
            {
              "radarr" = {
                description = "radarr starr";
                href = "http://achilles:7878";
                widget = {
                  type = "radarr";
                  url = "http://achilles:7878";
                  key = "ca501f07ba4e4af39283f2a1194b86c1";
                };
              };
            }
            {
              "readarr" = {
                description = "readarr starr";
                href = "http://achilles:8787";
                widget = {
                  type = "readarr";
                  url = "http://achilles:8787";
                  key = "1b7e812575f74ed0b009a9145f9fbe67";
                };
              };
            }
            {
              "flood" = {
                description = "flood! aah!";
                href = "http://achilles:3000";
                widget = {
                  type = "flood";
                  url = "http://achilles:3000";
                };
              };
              
            }
          ];
        }
    ];
  };

#	fileSystems."/nix" =
#	{ 
#		depends = ["/" "/speedy" ];
#		device = "/speedy/nix#/";
#		options = [ "bind" ];
#	};

#	fileSystems."/mntshare" = 
#	{
#		device = "192.168.0.2:/share";
#		fsType = "nfs";
#		options = [
#			"x-systemd.automount"
#				"x-systemd.idle-timeout=600"
#				"x-systemd.device-timeout=5s"
#				"x-systemd.mount-timeout=5s"
#				"noauto"
#				"nofail"
#				"defaults"
#		];
#	};

# Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/disk/by-id/nvme-KINGSTON_SNV3S500G_50026B7687140624-part3";
  #boot.loader.grub.useOSProber = true;
  # boot.loader.systemd-boot.enable = true;
    #   efiInstallAsRemovable = lib.mkForce false; # in case canTouchEfiVariables doesn't work for your system
    #   device = "/dev/nvme1n1p1";
    # };
    #grub = {
    #    enable = true;
    #    devices = [ "" "/dev/disk/by-id/nvme-TEAM_TM8FPK001T_112401230120828" "/dev/disk/by-id/wwn-0x50000395f42872dc" ];
    #};
  boot.loader = {
    
    limine.enable = true;
    #efi = {
    #  canTouchEfiVariables = true;
    # efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    #};
    #grub = {
    #   enable = true;
    #   useOSProber = true;
    #   device = "/dev/disk/by-id/nvme-KINGSTON_SNV3S500G_50026B7687140624";
    #};
  };

  networking.hostName = "achilles"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    virtualisation.docker.enable = true;
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
#  networking.networkmanager.enable = true;

# Set your time zone.
  time.timeZone = "Pacific/Auckland";

# Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";

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
#  services.xserver.enable = true;

# Enable the KDE Plasma Desktop Environment.
#  services.xserver.displayManager.sddm.enable = true;
#  services.xserver.desktopManager.plasma6.enable = true;

# Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "nz";
      variant = "";
    };
  };

# input-remapper for controller emulation from keyboard
#	services.input-remapper = {
#		enable = true;
#	};

  nix.extraOptions = ''
    trusted-users = root klara
    '';



# Enable CUPS to print documents.
  services.printing.enable = true;

# bluetooth support
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;

# Enable sound with pipewire.
#	sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

# this is for k3b- dont mind it
  security.wrappers = {
    cdrdao = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrdao}/bin/cdrdao";
    };
    cdrecord = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrtools}/bin/cdrecord";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

# Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = ["nvidia"];

  nix.settings.sandbox = true;
  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
  services.desktopManager.plasma6.enable = true;
  
  services.displayManager = {
    defaultSession = "plasmax11";
    autoLogin.enable = true;
    autoLogin.user = "klara";
  };

  services.xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
        
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
            VendorName "NVIDIA Corporation"
            Option      "AllowEmptyInitialConfiguration"
            Option      "ConnectedMonitor" "DVI-D-0"
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

  hardware.nvidia = {

# Modesetting is required.
    modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
    powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
# Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
#		package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;


# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;
  programs.zsh.enable = true;

#uinput group for /dev/uinput access

  boot.kernelModules = [ "uinput" "efivarfs" ];

  services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
    '';

  users.groups.uinput = {};
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.klara = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Klara =]";
    home = "/home/klara";
    extraGroups = [ "networkmanager" "wheel" "docker" "uinput" "cdrom" "dialout" "video" ];
    packages = with pkgs; [
      # chromium
#  thunderbird$
    ];
  };

  users.users.root = {
    extraGroups = [ "uinput" ];
  };

  #home-manager.users.klara = {
  #  programs.zsh = { enable = true;
  #    enableCompletion = true;
  #    autocd = true;
  #    initExtra = "export PATH=$PATH:/home/klara/.local/share/gem/ruby/3.3.7/bin;source ~/.frob_zsh_conf.sh\n";
  #    syntaxHighlighting.enable = true;
  #    enableAutosuggestions = true;
  #    history.size = 100000;
#
#      shellAliases = {
#        ll = "ls -l";
#        update = "sudo nixos-rebuild switch";
#
#        editnix = "sudo vim +/new_pkg /etc/nixos/configuration.nix && update";
#        editzsh = "editnix && source ~/.zshrc";	
#      };
#
#      oh-my-zsh = {
#        enable = true;
#        plugins = [ "git" ];
#        theme = "kphoen";
#      };
#    };

#    programs.neovim = {
#      enable = true;
#      defaultEditor = true;
#      viAlias = true;
#      vimAlias = true;
#      extraConfig = ''
#        set number relativenumber
#        '';
#    };
#
#    home.stateVersion = "23.11";
#  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
      "electron-25.9.0"
  ];
  nixpkgs.config.cudaSupport = false;
#

  #nix.settings = {
  #  substituters = [ "https://cache.nixos-cuda.org" ];
  #  trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  #};

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#  wget
    wineWowPackages.stable
      winetricks
      protontricks
      zsh
      # firefox
      vim
      vlc
      prismlauncher
      kitty
      neofetch
      bitwarden-desktop
      gimp
      lmms
      unzip
      linuxsampler
      qsampler
      texstudio
      texliveFull
      sqlite
      # libreoffice
      hunspell
      wget
      tmux
      gitFull
      vulkan-tools
      # chromium
# openjdk8
      jdk
      qdirstat
      burpsuite
      exiftool
      # python314Full
#       jetbrains.idea-community
      appimage-run
      binutils
      docker-compose
      dig
      metasploit
      exploitdb
      go
      vscodium
      ghostscript
      # ghidra
      runescape
      # transmission-gtk
      lutris
      # spotify
      (lutris.override {
       extraLibraries = pkgs: [

       ];
       })
       xorg.xrandr
       efibootmgr
       # cudatoolkit
  oci-cli
# ruby_3_3
    yarn
    gcc
    clang
    gnumake
    jq
    gparted
    # sqlitebrowser
    # yt-dlp
    ffmpeg
    anki-bin
    wireshark
    poppler-utils
    ripgrep
    linuxHeaders
    libevdev
    libinput
    ueberzug
    pdfcrack
    john
    hashcat
    darktable
    audacity
    # obsidian
    steamtinkerlaunch
    weylus
    cabal-install
# Commented out for 24.11		libsForQt5.k3b
    # llama-cpp
    # home-manager
    moonlight-qt
    dolphin-emu
    cockatrice
    nmap
    # android-studio
    android-tools
    nicotine-plus
    strawberry

#gstreamer for strawberry
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    devenv
    bundix
    libyaml
    zeal
    # kicad
    arduino
    arduino-ide
    firefox
# latest_package new_pkg latest_pkg new_package new_program latest_program
    ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

  programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.udisks2.enable = true;

#  services.ollama = {
#    enable = true;
#    acceleration = "cuda";
#  };
#services.open-webui = {
#		enable = true;
#		openFirewall = false;
#	};

  #services.sunshine = {
  ##  enable = true;
  #  # autoStart = true;
  #  capSysAdmin = true;
  #  openFirewall = true;
  #  settings = {
  #    origin_web_ui_allowed = "wan";
  #    origin_pin_allowed = "wan";
  #    wan_encryption_mode = 0;
  #    lan_encryption_mode = 0;
  #  };
  #};


  security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${ pkgs.sunshine.override({ config.cudaSupport = true; }) }/bin/sunshine";
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
          ''; in {
            ExecStart = "${config.security.wrapperDir}/sunshine ${sunshineConfigFile}/config/sunshine.conf";
            Restart = "on-failure";
            RestartSec = "5s";
        };
    };
    
    services.avahi.publish.userServices = true;

  services.joycond.enable = true;
  programs.joycond-cemuhook.enable = true;

  services.udev.packages = [ pkgs.dolphin-emu ];

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
#  networking.firewall.enable = false;
  services.tailscale.enable = true;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 3000 1701 9001 4000 8000 25567 64831 ];
    allowedTCPPortRanges = [
    { from = 1714; to = 1764; }
    ];
    allowedUDPPorts = [ 41641 ];
    allowedUDPPortRanges = [
    { from = 1714; to = 1764; }
    ];
  };


  environment.etc."current-system-packages".text =
    let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
  formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
}

