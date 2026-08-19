{ config, pkgs, nixpkgs, lib, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "runescape-launcher"
    "zoom"
    "obsidian"
    "burpsuite"
    "vintagestory"
  ];

  programs.steam.enable = true;
  programs.weylus = {
    enable = true;
    users = [ "klara" ];
    openFirewall = true;
  };
  programs.gnupg.agent.enable = true;
  # services.flatpak.enable = true;
  services.blueman.enable = true;
  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [
      wordnet
        deu2eng
        eng2deu
    ];
  };


  # from https://raw.githubusercontent.com/cm-b2g/B2G/1230463/tools/51-android.rules
  # and https://sites.google.com/view/bananahackers/development/adb?authuser=0
  # Also for gd-77 writing @ https://grid.radio/opengd77/
  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="1fc9", MODE="0664", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="15a2", MODE="0664", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="8137", MODE="0664", GROUP="plugdev"
  SUBSYSTEM=="usb-serial", ATTR{serial}=="0", MODE="0664", GROUP="plugdev"
  '';

  programs.firefox = {
    enable = true;
  };
  programs.zsh.enable = true;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets."tailscale-authkey.age".path;
    extraUpFlags = [ "--login-server" "https://hs.fem.nz/" ];
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
# don’t shutdown when power button is short-pressed

  programs.kdeconnect = { enable = true; };

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
      tmux
      gimp-with-plugins
      # gimpPlugins.resynthesizer
      gimpPlugins.gmic
      nufraw
      libreoffice
      vulkan-tools
      intel-gpu-tools
      git
      # deadbeef
      xbacklight
      prismlauncher
      file
      exiftool
      binwalk
      ghidra
      zsteg
      gdb
      wireshark
      tesseract
      anki
      ardour
      gnome-tweaks
      # kicad
      castnow
      gnomecast
      gnome-network-displays
      # mkchromecast
      devenv
      ripgrep
      libremines
      mpvpaper
      vlc
      waytrogen
      chafa
      vim
      powertop
      (callPackage ./derivations/hanabi.nix{}).hanabi
      gnomeExtensions.media-controls
      gnomeExtensions.desktop-clock
      gnomeExtensions.desktop-icons-ng-ding
      lutris
      # retroarch-full
      darktable
      lmms
      art
      zeal
      cockatrice
      transmission_4-qt
      jdk8
      jdk25
      sunshine
      wine
      krakatau2
      runelite
      (bolt-launcher.override { enableRS3 = true; })
      sshuttle
      audacity
      activitywatch
      android-tools
      testdisk
      foremost
      libwacom
      krita
      grim
      slurp
      wl-clipboard
      mako
      oculante
      swayosd
      upower
      networkmanager
      kdePackages.ark
      inkscape
      libuv
      wl-clipboard
      nmap
      pcmanfm
      rclone
      signal-desktop
      jetbrains.idea-oss
      obs-studio
      pavucontrol
      texstudio
      obs-studio
      qgis
      (flameshot.override { enableWlrSupport = true; })
      kdePackages.kdenlive
      vscodium
      wdisplays
      zoom-us
      compose2nix
      blender
      nixos-generators
      obsidian
      dive
      # docker-compose
      moonlight-qt
      unzip
      ncdu
      mpv
      sshfs
      burpsuite
      nixfmt
      gqrx
      rtl_433
      sdrpp
      multimon-ng
      krita
      vintagestory
      espeak
      strawberry
      gnumake
      gcc
      gcc-arm-embedded
      dtc
      #vim
      #strawberry-qt
# new_pkg
      # (callPackage "${(builtins.fetchTarball {
      #   url = "https://github.com/ryantm/agenix/archive/main.tar.gz";
      #   sha256 = "sha256-Ks+p8geHkzSc2z51GOiugLDqxy8lgNhF/2o3Pc/a9VU=";
      #   })}/pkgs/agenix.nix")
      ];
}
