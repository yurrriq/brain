{
  description = "Stuff I know";

  inputs = {
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, emacs-overlay, nixpkgs }:
    let
      pkgs = import nixpkgs {
        overlays = [
          emacs-overlay.overlay
        ];
        system = "x86_64-linux";
      };
    in
    {
      devShell.x86_64-linux = with pkgs; mkShell {
        buildInputs = [
          (
            emacsWithPackagesFromUsePackage {
              alwaysEnsure = true;
              config = ./emacs.el;
              extraEmacsPackages = epkgs: [
                epkgs.org-roam-ui
              ];
            }
          )
          gitAndTools.pre-commit
          gnumake
          nixpkgs-fmt
          poppler_utils
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
    };
}
