# Common Functions for NixOS
with builtins;
rec {
  readFileRel = x: readFile (../. + x);
  readDirList = x: attrNames (readDir  (../. + x));
  dirCMap = f: x: foldl' (y: z: y + (f z)) "" (readDirList x);
  readDirStr = x: dirCMap (y: readFileRel (x + y)) x;
  shellAlias = x: y: "alias nix-${y}='nix develop ~/.nixos${x}${y} -c zsh'\n";
  readShells = x: dirCMap (shellAlias x) x;
}
