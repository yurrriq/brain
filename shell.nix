{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gnumake
    niv
    nixpkgs-fmt
    obsidian
    poppler_utils
    python3Packages.pre-commit
    (
      texlive.combine {
        inherit (texlive) scheme-small
          currfile
          filemod
          latexmk
          standalone
          tikz-cd
          ;
      }
    )
  ];
}
