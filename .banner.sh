#!/usr/bin/env bash

___devtools___() {
  local tool_name
  local tool_path
  local tool_version
  local version_output
  local color_name
  local color_version
  local color_missing
  local color_reset

  if [ -t 1 ]; then
    color_name='\033[1;36m'
    color_version='\033[1;32m'
    color_missing='\033[1;31m'
    color_reset='\033[0m'
  else
    color_name=''
    color_version=''
    color_missing=''
    color_reset=''
  fi

  for tool_name in codex npm uv fnm fd fzf batcat nvim go; do
    tool_path="$(command -v "$tool_name" 2>/dev/null)"

    if [ -z "$tool_path" ]; then
      printf '%b%s%b (missing)\n' "$color_missing" "$tool_name" "$color_reset"
      printf '  └── not found\n'
      continue
    fi

    case "$tool_name" in
      go)
        version_output="$("$tool_path" version 2>&1)"
        ;;
      *)
        version_output="$("$tool_path" --version 2>&1)"
        ;;
    esac

    tool_version="$(printf '%s\n' "$version_output" | grep -Eo '[vV]?[0-9]+(\.[0-9]+)+' | head -n 1)"
    tool_version="${tool_version#[vV]}"
    [ -n "$tool_version" ] || tool_version="unknown"

    printf '%b%s%b (%b%s%b)\n' "$color_name" "$tool_name" "$color_reset" "$color_version" "$tool_version" "$color_reset"
    printf '  └── %s\n' "$tool_path"
  done
}
