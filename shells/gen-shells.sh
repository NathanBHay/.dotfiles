#!/usr/bin/env bash
# Generates dev-shell helper aliases from a flake.nix "# Shells:" comment.
# Usage: source this script, or `eval "$(./gen-shells.sh /path/to/nixos)"`

NIXOS_DIR="${1:-$HOME/.dotfiles/shells}"

gen_shells() {
  local dir="$1"
  local flake="$dir/flake.nix"

  [ -f "$flake" ] || { echo "no flake.nix in $dir" >&2; return 1; }

  # Match lines like:  name = pkgs.mkShell {
  # Capture the leading identifier as the shell name.
  local names
  names=$(grep -oE '^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*=[[:space:]]*pkgs\.mkShell' "$flake" \
            | grep -oE '[a-zA-Z_][a-zA-Z0-9_-]*' \
            | grep -v '^pkgs$' \
            | grep -v '^mkShell$')

  for y in $names; do
    printf 'export %s_shell=%s#%s\n' "$y" "$dir" "$y"
    printf "alias nix-%s='nix develop \$%s_shell -c zsh'\n" "$y" "$y"
    printf "alias envrc-%s='printf \"use flake \$%s_shell\\\\nif git rev-parse --is-inside-work-tree > /dev/null 2>&1; then\\\\n  onefetch -d churn\\\\nfi\\\\n\" > .envrc'\n" "$y" "$y"
  done
}

gen_shells "$NIXOS_DIR"
