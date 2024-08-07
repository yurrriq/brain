{
  description = "Stuff I know";

  inputs = {
    emacs-overlay = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:nix-community/emacs-overlay";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    pre-commit-hooks-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:cachix/git-hooks.nix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  nixConfig = {
    commit-lockfile-summary = "build(deps): nix flake update";
  };

  outputs = inputs@{ emacs-overlay, flake-parts, nixpkgs, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      flake.overlays.default = _final: prev: {
        logseq = prev.logseq.override {
          electron = prev.electron_30;
        };
        # FIXME: treefmt-nix doesn't seem to support v2 yet
        treefmt = prev.treefmt1;
      };

      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          overlays = [
            emacs-overlay.overlay
            self.overlays.default
          ];
          inherit system;
        };

        devShells.default = pkgs.mkShell {
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [
              (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
            ];
          };
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
              "docs/**"
            ];
          };
        };
      };
    };
}
