# nix-configs

This is a collection of files to be kept in /etx/nixos/ for my personal configuration(s). Hopefully doesn't contain any secrets ;)

Contents:
* configuration.nix - Base configuration & importing other files
* power-configuration.nix - Power management for laptop. Could be a child of hardware-configuration (TBD)
* user-configuration.nix - Configures users (excluding home-manager stuff)
* package-configuration.nix - System packages
* home-configuration.nix - System-wide home-manager

* modules/ - modules (?!)
* scripts/ - shell scripts to be used elsewhere
* derivations/ - derivations. hopefully won't be much in here
