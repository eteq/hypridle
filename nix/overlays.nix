{
  lib,
  inputs,
}: let
  mkDate = longDate: (lib.concatStringsSep "-" [
    (builtins.substring 0 4 longDate)
    (builtins.substring 4 2 longDate)
    (builtins.substring 6 2 longDate)
  ]);
in {
  default = inputs.self.overlays.hypridle;

  hypridle = lib.composeManyExtensions [
    inputs.hyprlang.overlays.default
    inputs.hyprutils.overlays.default
    (final: prev: {
      hypridle = prev.callPackage ./default.nix {
        stdenv = prev.gcc13Stdenv;
        version = "0.pre" + "+date=" + (mkDate (inputs.self.lastModifiedDate or "19700101")) + "_" + (inputs.self.shortRev or "dirty");
        inherit (final) hyprlang;
      };
    })
  ];
}
