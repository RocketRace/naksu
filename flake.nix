{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Enable apps to show up in spotlight
    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";
    # VSCode extensions are not in nixpkgs
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    # Firefox on darwin is broken in nixpkgs as of now, we use an overlay
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixpkgs-firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    home-manager,
    nix-darwin,
    nixpkgs,
    mac-app-util,
    nix-vscode-extensions,
    nixpkgs-firefox-darwin,
  }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#pigeon
    darwinConfigurations."pigeon" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.olivia = import ./home.nix;
          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
