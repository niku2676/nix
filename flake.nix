{
  description = "NixOS configuration for buls";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";

    illogical-impulse = {
      url = "github:xBLACKICEx/end-4-dots-hyprland-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    disko,
    lanzaboote,
    illogical-impulse,
    sops-nix,
    ...
  }:
    let
      mkSystem = bootstrap: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs bootstrap; };

        modules = [
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ./hosts/buls
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs bootstrap; };
            home-manager.users.nikita = import ./home/nikita;
          }
        ];
      };
    in {
      nixosConfigurations = {
        buls = mkSystem false;
        buls-bootstrap = mkSystem true;
      };
    };
}
