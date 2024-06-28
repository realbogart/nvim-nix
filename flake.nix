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
          url = "https://github.com/realbogart/nvim.git";
          rev = "fc797f1bd8164ba01048d3be32849ef9c10b2042";
          submodules = true;
        };
        dependencies = with pkgs; [ neovim ripgrep git nil nixfmt ];
      in rec {
        packages.default = pkgs.writeShellApplication {
          name = "nvim-johan";
          runtimeInputs = dependencies ++ [ nvim-config ];
          text = ''
            export XDG_CONFIG_HOME=${nvim-config}
            export NVIM_APPNAME='./'
            export TERM=tmux-256color
            export LANG=en_US.UTF-8
            nvim
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = dependencies ++ [ packages.default ];
          shellHook = "";
        };
      });
}
