{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    # Darwin + nixos shared inputs:
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # (VSCode extensions are not in nixpkgs)
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    # Darwin-specific inputs:
    # Enable apps to show up in spotlight
    # mac-app-util is not building for some reason
    # mac-app-util.url = "github:hraban/mac-app-util";
    # mac-app-util.inputs.nixpkgs.follows = "nixpkgs-darwin";
    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-darwin,
    nix-darwin,
    home-manager,
    # mac-app-util,
    nix-vscode-extensions,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    nix-rosetta-builder,
  }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#pigeon
    darwinConfigurations."pigeon" = nix-darwin.lib.darwinSystem {
      modules = [
        {
          # TEMPORARY, NODEJS DOESN'T BUILD ON 24.11
          nixpkgs.overlays = [
            (self: super: {
              nodejs = super.nodejs_22;
            })
          ];
        }
        ./darwin.nix
        # mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.olivia = import ./home-manager/pigeon.nix;
          home-manager.sharedModules = [
            # mac-app-util.homeManagerModules.default
          ];
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
        # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
        # If one isn't already available: comment out the `nix-rosetta-builder` module below,
        # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
        # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
        # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
        # nix-rosetta-builder.darwinModules.default
        # {
        #   # see available options in module.nix's `options.nix-rosetta-builder`
        #   nix-rosetta-builder.onDemand = true;
        # }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "olivia";
            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
    # Build nixos flake using:
    # $ nixos-rebuild build --flake .#magpie
    nixosConfigurations."magpie" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.olivia = ./home-manager/magpie.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };
  };
}
