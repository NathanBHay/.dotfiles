# Common Functions for NixOS
with builtins;
rec {
  readFileRel = x: readFile (../. + x);
  readDirList = x: g: filter g (attrNames (readDir (../. + x)));
  dirCMap =
    f: x: g:
    foldl' (y: z: y + (f z)) "" (readDirList x g);
  readDirStr = x: g: dirCMap (y: readFileRel (x + y)) x g;

  shellPath = x: y: ''
    export ${y}_shell=~/.nixos${x}#${y}
  '';
  shellAlias = y: ''
    alias nix-${y}='nix develop ''$${y}_shell -c zsh'
  '';
  shellEnvrc = y: ''
    alias envrc-${y}='echo "use flake ''$${y}_shell
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      onefetch
    fi" > .envrc'
  '';
  shellLink = x: y: (shellPath x y) + (shellAlias y) + (shellEnvrc y) + "\n";
  regex = "^# Shells:([[:alnum:][:blank:]]*).*";
  extractShells = x: split "([[:blank:]]+)" (head (match regex x));
  nonEmptyStr = x: isString x && x != "";
  listShells = x: filter nonEmptyStr (extractShells (readFileRel x));
  concatMapStr = f: x: concatStringsSep "" (map f x);
  readShells = x: concatMapStr (shellLink x) (listShells (x + "/flake.nix"));
}
