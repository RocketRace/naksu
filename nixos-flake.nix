{
  description = "My system configuration 2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager
}:
  {
    # Build nixos flake using:
    # $ nixos-rebuild build --flake .#magpie
    nixosConfigurations."magpie" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos-configuration.nix
      ];
    };
  };
}
