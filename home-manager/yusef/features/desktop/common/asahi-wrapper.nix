{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux isAarch64;
  isAsahi = (isLinux && isAarch64);
in 
{ package
, name
, paths ? []
, gl-version ? "3.3"
, gles-version ? "3.0"
, glsl-version ? "330"
}: if (! isAsahi) then package else pkgs.symlinkJoin {
    inherit name;
    paths = [ package ] ++ paths;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/${name}" \
        --set "MESA_GL_VERSION_OVERRIDE" "${gl-version}" \
        --set "MESA_GLES_VERSION_OVERRIDE" "${gles-version}" \
        --set "MESA_GLSL_VERSION_OVERRIDE" "${glsl-version}"
    '';
   }

