{
  description = "My neovim setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        dependencies = with pkgs; [ neovim ];
      in {
        packages.default = pkgs.writeShellApplication {
          name = "nvim-johan";
          runtimeInputs = dependencies;
          text = ''
            echo LOL
          '';
        };
        devShells.default = pkgs.mkShell {
          packages = dependencies;
          shellHook = ''
            echo Hello
          '';
        };
      });
}
