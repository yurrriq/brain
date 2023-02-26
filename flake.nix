{
  description = "Stuff I know";

  inputs = {
    deadnix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:astro/deadnix";
    };
    emacs-overlay = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/emacs-overlay";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { emacs-overlay, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [
            inputs.deadnix.overlays.default
            emacs-overlay.overlay
          ];
          inherit system;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            deadnix
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
            nixpkgs-fmt
            poppler_utils
            pre-commit
            (
              texlive.combine {
                inherit (texlive) scheme-small
                  currfile
                  dvipng
                  filemod
                  latexmk
                  standalone
                  tikz-cd
                  ;
              }
            )
          ];
        };
      });
}
