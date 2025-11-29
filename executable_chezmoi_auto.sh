#!/bin/bash
set -euo pipefail

# Auto-add files to chezmoi with optional non-interactive mode (--yes/--add)

usage() {
  cat <<EOF
Usage: $0 [--add|--yes] [--help]

  --add    Run actions without confirmation (alias for --yes)
  --yes    Run actions without confirmation
  --help   Show this help message
EOF
}

# Parse arguments
QUICK_YES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
  --add | --yes)
    QUICK_YES=1
    shift
    ;;
  --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 2
    ;;
  esac
done

# Get chezmoi status
status_output=$(chezmoi status)

# Extract relevant changed files (source/dest states + path)
files_to_add=$(awk '
  {
    s=substr($0,1,1); d=substr($0,2,1); p=substr($0,4);
    if (s ~ /[AM?]/ || d ~ /[AM?]/)
      printf("%s|%s|%s\n", s, d, p)
  }
' <<<"$status_output")

if [[ -z "$files_to_add" ]]; then
  echo "No changes found to add."
  exit 0
fi

# Colors only if TTY
if [[ -t 1 ]]; then
  ESC=$'\033['
  RESET="${ESC}0m"
  BOLD="${ESC}1m"
  RED="${ESC}31m"
  GREEN="${ESC}32m"
  YELLOW="${ESC}33m"
  BLUE="${ESC}34m"
else
  RESET=""
  BOLD=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
fi

declare -a COMMANDS ACTIONS TARGETS
updates=0
skipped=0
forgot=0
errors=0

# Process each changed file entry
while IFS='|' read -r src dst file; do
  [[ -z "$file" ]] && continue

  # Normalize state fields
  src=${src//[[:space:]]/}
  dst=${dst//[[:space:]]/}
  [[ -z "$src" ]] && src='-'
  [[ -z "$dst" ]] && dst='-'

  # Compute absolute path
  if [[ "$file" = /* ]]; then
    target="$file"
  else
    target="$HOME/$file"
  fi

  # Case: both deleted → skip
  if [[ $src = "D" && $dst = "D" ]]; then
    printf "  %sSkipping:%s both source and destination deleted: %s\n" "$YELLOW" "$RESET" "$file"
    ((skipped++))
    continue
  fi

  # Case: destination removed but source exists → user should apply or forget
  if [[ $dst = "D" && $src != "D" ]]; then
    printf "  %sNote:%s destination deleted but source present: %s\n" "$YELLOW" "$RESET" "$file"
    printf "    Suggestion: 'chezmoi apply' or 'chezmoi forget'\n"
    ((skipped++))
    continue
  fi

  # Case: source deleted but destination exists → forget action
  if [[ $src = "D" && $dst = "A" ]]; then
    COMMANDS+=("chezmoi forget \"$target\"")
    ACTIONS+=("forget")
    TARGETS+=("$target")
    ((forgot++))
    continue
  fi

  # Case: file does not exist locally → apply to restore
  if [[ ! -e "$target" ]]; then
    if [[ $src = "M" || $dst = "M" ]]; then
      printf "  %sAction:%s apply (restore): %s\n" "$BLUE" "$RESET" "$file"
      COMMANDS+=("chezmoi apply -- \"$file\"")
      ACTIONS+=("apply")
      TARGETS+=("$target")
      ((updates++))
      continue
    fi
    printf "  %sWarning:%s target does not exist, skipping: %s\n" "$YELLOW" "$RESET" "$target"
    ((skipped++))
    continue
  fi

  # Default: add/update
  COMMANDS+=("chezmoi add \"$target\"")
  ACTIONS+=("update")
  TARGETS+=("$target")
  ((updates++))

done <<<"$files_to_add"

echo
printf "%sPlanned actions:%s\n" "$BOLD" "$RESET"

for i in "${!COMMANDS[@]}"; do
  case "${ACTIONS[$i]}" in
  update) printf "  %s+ update%s %s\n" "$GREEN" "$RESET" "${TARGETS[$i]}" ;;
  apply) printf "  %s~ apply%s %s\n" "$BLUE" "$RESET" "${TARGETS[$i]}" ;;
  forget) printf "  %s- forget%s %s\n" "$YELLOW" "$RESET" "${TARGETS[$i]}" ;;
  esac
done

# Ask for confirmation unless --yes
if ((QUICK_YES == 0)); then
  read -p "Proceed with the above operations? [y/N] " reply
  [[ $reply =~ ^[Yy]$ ]] || {
    echo "Aborted."
    exit 0
  }
fi

# Execute actions
for i in "${!COMMANDS[@]}"; do
  printf "%sExecuting:%s %s\n" "$BOLD" "$RESET" "${COMMANDS[$i]}"
  eval "${COMMANDS[$i]}" || {
    printf "%sError:%s command failed: %s\n" "$RED" "$RESET" "${COMMANDS[$i]}"
    ((errors++))
  }
done

echo
printf "%sFinal Summary:%s\n" "$BOLD" "$RESET"
printf "  Updates: %s\n" "$updates"
printf "  Forgets: %s\n" "$forgot"
printf "  Skipped: %s\n" "$skipped"
printf "  Errors:  %s\n" "$errors"

echo "Done!"
((QUICK_YES == 1)) && echo "Note: non-interactive mode enabled."
