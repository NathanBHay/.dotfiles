#!/bin/sh

# Window Duplicator
windowdup() {
  # Get the current window details
  local pid=$(hyprctl activewindow | awk '/pid/ {print $2}')
  local title=$(hyprctl activewindow | awk '/title:/ {print substr($0, index($0,$2))}')

  # Get the command to launch window and args
  local cmd=$(ps -p $pid -o cmd=)

  # TODO: Fix args
  local args=""
  if [[ title == "zsh" ]]; then
    args=$(readlink /proc/$pid/cwd)
  fi
  # Launch to new window
  nohup $cmd $args > /dev/null 2>&1 &
}

windowdup
