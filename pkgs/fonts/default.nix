{ lib, callPackage }:
let
  inherit (builtins) readDir attrNames listToAttrs;
  inherit (lib.attrsets) filterAttrs nameValuePair;
  inherit (lib.lists) forEach;

  p = path: (callPackage path {});

  # get a list of all subdirectories of this dir
  dirs = 
    attrNames 
      (filterAttrs
        (name: type: type == "directory")
        (readDir ./.));
  
  # make an attrset where the keys are the directory name,
  # and the values are the result of (callPackage ./${dir-name} {})
  packages = 
   listToAttrs
    (forEach 
      dirs
      (dir: (nameValuePair dir (p ./${dir}))));
in
packages
