mdiagram() {
  local input="$1"
  local output="${2:-${input%.*}.svg}"

  if ! command -v mmdc &>/dev/null || ! command -v entr &>/dev/null; then
    echo "❌ Please ensure both mmdc (Mermaid CLI) and entr (file watcher) are installed first."
    return 1
  fi

  # Check if the input file exists
  if [ ! -f "$input" ]; then
    echo "\`\`\`mermaid\n\n\`\`\`" > "$input"
  fi
  echo $input
  echo $output

  # Start entr to watch the .mmd file and regenerate the .svg
  echo "$input" | entr -c sh -c 'mmdc -i "$0" -o "$1" && $2 "$1"' "$input" "$output" "$BROWSER"
}
