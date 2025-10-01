{
  description = "Stuff I know";

  inputs = {
    emacs-overlay = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:nix-community/emacs-overlay";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/git-hooks.nix";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  nixConfig = {
    commit-lockfile-summary = "build(deps): nix flake update";
  };

  outputs = inputs@{ emacs-overlay, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
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

        devShells.default = pkgs.mkShell {
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [
              pkgs.nerd-fonts.iosevka
            ];
          };

          inputsFrom = [
            config.pre-commit.devShell
          ];

          nativeBuildInputs = with pkgs; [
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
            logseq
            poppler_utils
            ripgrep
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
        };

        pre-commit.settings.hooks = {
          treefmt.enable = true;
        };

        treefmt = {
          programs = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
          };
          settings.formatter = {
            prettier.excludes = [
              "docs/**"
            ];
          };
        };
      };
    };
}
