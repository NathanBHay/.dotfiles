# shellcommands.sh - A collection of shell commands used inside shells

# Mermaod diagram generator
# Usage: mdiagram <input.mmd> [output.svg]
mdiagram() {
  local input="$1"
  local output="${2:-${input%.*}.svg}"

  if ! command -v mmdc &>/dev/null || ! command -v entr &>/dev/null; then
    echo "❌ Please ensure both mmdc (Mermaid CLI) and entr (file watcher) are installed first."
    return 1
  fi

  # Check if the input file exists
  if [ ! -f "$input" ]; then
    echo "❌ Please ensure input file exists" >"$input"
  fi

  # Start entr to watch the .mmd file and regenerate the .svg
  $BROWSER "$output"
  echo "$input" | entr -c sh -c 'mmdc -i "$0" -o "$1"' "$input" "$output"
}

# Run pwndbg for a specific test case, setting a breakpoint when it starts
# Usage: pwntest <binary> <function>
pwntest() {
  pwndbg $1 --ex "rbreak $2" --ex "set args $2"
}
