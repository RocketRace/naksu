{
  description = "Python project using poetry";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, poetry2nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (sys:
    let
      pkgs = nixpkgs.legacyPackages.${sys};
      python = pkgs.python313;
      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv overrides;
      problematic-dependencies = (deps: overrides.withDefaults
        (final: prev:
          (builtins.mapAttrs (dep: extras:
            prev.${dep}.overridePythonAttrs
            (old: {
              buildInputs = (old.buildInputs or [ ]) ++ map (package: prev.${package}) extras;
            })
          ) deps)
        ));
      env = mkPoetryEnv {
        projectDir = ./.;
        inherit python;
        preferWheels = true;
        extraPackages = (pkgs: [ pkgs.pip ]);
        overrides = problematic-dependencies { };
      };
    in 
    {
      devShells.default = pkgs.mkShell {
        buildInputs = [ env ];
        packages = [ pkgs.poetry ];
      };
    }
  );
}
