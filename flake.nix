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
        nvim-config = builtins.fetchGit {
          url = "git@github.com:realbogart/nvim.git";
          rev = "af8f84762a4ce3d4339fd3b7c59f977a65da0152";
          submodules = true;
        };
        dependencies = with pkgs; [ neovim ];
      in rec {
        packages.default = pkgs.writeShellApplication {
          name = "nvim-johan";
          runtimeInputs = dependencies ++ [ nvim-config ];
          text = ''
            export XDG_CONFIG_HOME=${nvim-config}
            export NVIM_APPNAME='./'
            nvim
          '';
        };
        devShells.default = pkgs.mkShell {
          packages = dependencies ++ [ packages.default ];
          shellHook = "";
        };
      });
}
