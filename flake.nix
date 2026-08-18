{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/26.05";
  # inputs.nixpkgstwentyfiveeleven.url = "github:NixOS/nixpkgs/25.11";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  inputs.agenix.url = "github:ryantm/agenix";

  # inputs.nixvim = {
  #   url = "github:nix-community/nixvim";
  #   # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
  #   # url = "github:nix-community/nixvim/nixos-26.05";

  #   inputs.nixpkgs.follows = "nixpkgs";
  # };

  outputs =
  {
    nixpkgs,
    nixpkgstwentyfiveeleven,
    disko,
    nixos-facter-modules,
    agenix,
    # nixvim,
    ...
  }:
  {
    nixosConfigurations.the-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./the-machine/configuration.nix
        ./the-machine/hardware-configuration.nix
        ./base/configuration.nix
        agenix.nixosModules.default

        {
          environment.systemPackages = [ agenix.packages."x86_64-linux".default ];
        }
      ];
    };

    nixosConfigurations.desk-friend = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./desk-friend/configuration.nix
        ./desk-friend/hardware-configuration.nix
        ./base/configuration.nix
        agenix.nixosModules.default

        {
          environment.systemPackages = [ agenix.packages."x86_64-linux".default ];
        }
      ];
    };

    nixosConfigurations.achilles = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        #disko.nixosModules.disko
        ./achilles/configuration.nix
        ./achilles/hardware-configuration.nix
        ./base/configuration.nix
        agenix.nixosModules.default

        {
          environment.systemPackages = [ agenix.packages."x86_64-linux".default ];
        }
      ];
    };

    nixosConfigurations.dusty-cobweb = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        disko.nixosModules.disko
        ./dusty-cobweb/configuration.nix
        ./base/configuration.nix
        agenix.nixosModules.default

        {
          environment.systemPackages = [ agenix.packages."aarch64-linux".default ];
        }
      ];
    };
  };
}
