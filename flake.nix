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
        nvim-config = pkgs.fetchFromGitHub {
          owner = "realbogart";
          repo = "nvim";
          rev = "ab901da67e6759b5748e6cc7e4a8ea2993143a73";
          hash = "sha256-fOESLAdK8I3CZvEABLQo3xwpV7ekMp0kbIvW8Wzeu6k=";
        };
        dependencies = with pkgs; [ neovim ] ++ [ nvim-config ];
      in rec {
        packages.default = pkgs.writeShellApplication {
          name = "nvim-johan";
          runtimeInputs = dependencies;
          text = ''
            nvim -u ${nvim-config}/init.lua
          '';
        };
        devShells.default = pkgs.mkShell {
          packages = dependencies ++ [ packages.default ];
          shellHook = "";
        };
      });
}
