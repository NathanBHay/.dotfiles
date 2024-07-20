# Common Functions for NixOS
with builtins;
rec {
  readFileRel = x: readFile (../. + x);
  readDirList = x: attrNames (readDir  (../. + x));
  dirCMap = f: x: foldl' (y: z: y + (f z)) "" (readDirList x);
  readDirStr = x: dirCMap (y: readFileRel (x + y)) x;

  shellAlias = x: y: "alias nix-${y}='nix develop ~/.nixos${x}#${y} -c zsh'\n";
  regex = "^\# Shells:([[:alnum:][:blank:]]*).*";
  extractShells = x: split "([[:blank:]]+)" (head (match regex x));
  nonEmptyStr = x: isString x && x != "";
  listShells = x: filter nonEmptyStr (extractShells (readFileRel x));
  concatMapStr = f: x: concatStringsSep "" (map f x);
  readShells = x: concatMapStr (shellAlias x) (listShells (x + "/flake.nix"));
}
