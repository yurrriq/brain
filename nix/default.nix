let
  sources = import ./sources.nix;
in
import sources.nixpkgs {
  overlays = [
    (_: pkgs: {
      obsidian =
        let
          src = sources.obsidian;
        in
        pkgs.obsidian.overrideAttrs (_: rec {
          inherit (src) version;
          inherit src;
        });
    })
  ];
}
