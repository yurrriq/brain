{
  description = "Stuff I know";

  inputs = {
    emacs-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/emacs-overlay";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ emacs-overlay, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          overlays = [
            emacs-overlay.overlay
          ];
          inherit system;
        };

        devShells.default = with pkgs; mkShell {
          nativeBuildInputs = [
            (
              emacsWithPackagesFromUsePackage {
                alwaysEnsure = true;
                config = ./emacs.el;
                extraEmacsPackages = epkgs: [
                  epkgs.org-roam-ui
                ];
              }
            )
            gnumake
            graphviz
            poppler_utils
            (
              texlive.combine {
                inherit (texlive) scheme-small
                  currfile
                  dvipng
                  filemod
                  latexmk
                  standalone
                  svn-prov
                  tikz-cd
                  ;
              }
            )
          ];

          inherit (config.pre-commit.devShell) shellHook;
        };

        pre-commit.settings.hooks = {
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ./flake.nix;
          programs = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
          };
          settings.formatter = {
            prettier.excludes = [
              "**/.obsidian/**"
              "docs/**"
            ];
          };
        };
      };
    };
}
