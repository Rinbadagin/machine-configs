{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs =
  {
    nixpkgs,
    disko,
    nixos-facter-modules,
    agenix,
    ...
  }:
  {
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
