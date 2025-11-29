#!/bin/bash
set -euo pipefail

# Auto-add files to chezmoi
# Default behavior: show planned actions and prompt for confirmation.
# Use --add or --yes to run planned actions non-interactively.

usage() {
  cat <<EOF
Usage: $0 [--add|--yes] [--help]

  --add    Run planned operations and skip confirmation (alias for --yes)
  --yes    Run planned operations and skip confirmation
  --help   Show this help message
EOF
}

# By default: no immediate execution. We'll show what will be done and ask
# for confirmation before executing. Use --yes or --add to skip the prompt.
QUICK_YES=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --add) QUICK_YES=1; shift ;; # compatibility: acts like --yes
    --yes) QUICK_YES=1; shift ;; # skip confirmation
    --help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

# Run chezmoi status and store the output
status_output=$(chezmoi status)

# Extract all files where the destination state indicates the destination has
# an added or modified file (including untracked). The output of `chezmoi status`
# prints the source/dest state as the first two characters, so check the second
# character and print the path starting in column 4 (so spaces in filenames are kept).
files_to_add=$(printf "%s\n" "$status_output" | awk '{s=substr($0,1,1); d=substr($0,2,1); if(s ~ /[AM?]/ || d ~ /[AM?]/) printf "%s|%s|%s\n", s, d, substr($0,4)}')

# If no changes are found, print a message and exit the script
if [ -z "$(printf '%s' "$files_to_add")" ]; then
  echo "No changes found to add."
  exit 0
fi

# Iterate lines safely (handles filenames with spaces)
updates=0
skipped=0
errors=0
forgot=0
declare -a COMMANDS
declare -a ACTIONS
declare -a TARGETS

# Setup colors if output is a TTY
if [ -t 1 ]; then
  # Use $'...' to expand escape sequences; avoids printing literal \033
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
while IFS='|' read -r src dst file; do
  # Normalize src/dst: remove whitespace and default to '-' when empty
  src="${src//[[:space:]]/}"
  dst="${dst//[[:space:]]/}"
  [ -z "$src" ] && src='-'
  [ -z "$dst" ] && dst='-'
  # ensure src/dst vars are not empty strings; use '-' if empty
  [ -z "$src" ] && src='-'
  [ -z "$dst" ] && dst='-'
  [ -z "$file" ] && continue

  # Determine the absolute path to pass to `chezmoi add/forget`.
  if [[ "$file" = /* ]]; then
    target="$file"
  else
    target="$HOME/$file"
  fi

  # If both source and destination are deleted, nothing to do.
  if [ "$src" = "D" ] && [ "$dst" = "D" ]; then
    printf "  %sSkipping:%s both source and destination deleted: %s\n" "$YELLOW" "$RESET" "$file"
    skipped=$((skipped + 1))
    continue
  fi

  # If destination is deleted (but source is present), the repository has a file
  # but the target in the home dir was removed. We won't auto-add; suggest
  # restoration via 'chezmoi apply' or removing from the source with 'chezmoi forget'.
  if [ "$dst" = "D" ] && [ "$src" != "D" ]; then
    printf "  %sNote:%s destination deleted but source present: %s\n" "$YELLOW" "$RESET" "$file"
    printf "    Suggestion: 'chezmoi apply' to restore destination, or 'chezmoi forget' to remove from source\n"
    skipped=$((skipped + 1))
    continue
  fi

  # If the source is deleted and destination still exists (DA), the file
  # appears to be deleted from the repository but still present locally. We
  # propose a `chezmoi forget` action for those files.
  if [ "$src" = "D" ] && [ "$dst" = "A" ]; then
    # Forget candidate: user deleted the file from the source but it's still
    # present locally. We propose a forget action.
    cmd=("chezmoi" "forget" "$target")
    COMMANDS+=("${cmd[*]}")
    ACTIONS+=("forget")
    TARGETS+=("$target")
    forgot=$((forgot + 1))
    continue
  fi

  # Determine the absolute path to pass to `chezmoi add`.
  if [[ "$file" = /* ]]; then
    target="$file"
  else
    target="$HOME/$file"
  fi

  # Skip if the target doesn't exist, to avoid chezmoi lstat errors
  if [ ! -e "$target" ]; then
    printf "  %sWarning:%s target does not exist, skipping: %s\n" "$YELLOW" "$RESET" "$target"
    skipped=$((skipped + 1))
    continue
  fi

  # Prepare command; we'll show them all and ask for confirmation before execution
  cmd=("chezmoi" "add" "$target")
  COMMANDS+=("${cmd[*]}")
  TARGETS+=("$target")
  ACTIONS+=("update")
  updates=$((updates + 1))
done <<< "$files_to_add"

# Print summary of planned actions
echo
printf "%sPlanned actions:%s\n" "$BOLD" "$RESET"
for i in "${!COMMANDS[@]}"; do
  act=${ACTIONS[$i]}
  cmd=${COMMANDS[$i]}
  case "$act" in
    update)
      printf "  %s+ update%s %s\n" "$GREEN" "$RESET" "${TARGETS[$i]}"
      ;;
    forget)
      printf "  %s- forget%s %s\n" "$YELLOW" "$RESET" "${TARGETS[$i]}"
      ;;
    *)
      printf "  %s? unknown%s %s\n" "$BLUE" "$RESET" "${cmd#* }"
      ;;
  esac
done

echo
printf "%sSummary of planned operations:%s\n" "$BOLD" "$RESET"
if [ "$updates" -gt 0 ]; then
  printf "  %sUpdates:%s %s\n" "$GREEN" "$RESET" "$updates"
fi
if [ "$forgot" -gt 0 ]; then
  printf "  %sForgets:%s %s\n" "$YELLOW" "$RESET" "$forgot"
fi
if [ "$skipped" -gt 0 ]; then
  printf "  %sSkipped:%s %s\n" "$BLUE" "$RESET" "$skipped"
fi
if [ "$errors" -gt 0 ]; then
  printf "  %sErrors:%s %s\n" "$RED" "$RESET" "$errors"
fi

if [ ${#COMMANDS[@]} -eq 0 ]; then
  echo "No operations to perform. Exiting."
  exit 0
fi

# Ask for confirmation unless --yes is specified
if [ "$QUICK_YES" -eq 0 ]; then
  read -p "Proceed with the above operations? [y/N] " reply
  case "$reply" in
    [yY]|[yY][eE][sS])
      ;; # proceed
    *)
      echo "Aborted by user"
      exit 0
      ;;
  esac
fi

# Execute planned commands
for i in "${!COMMANDS[@]}"; do
  act=${ACTIONS[$i]}
  cmd_str=${COMMANDS[$i]}
  printf "%sExecuting:%s %s\n" "$BOLD" "$RESET" "${cmd_str#* }"
  # Evaluate the command string safely
  eval $cmd_str || {
    printf "%sError:%s command failed: %s\n" "$RED" "$RESET" "$cmd_str"
    errors=$((errors + 1))
  }
done

echo
printf "%sFinal Summary:%s\n" "$BOLD" "$RESET"
if [ "$updates" -gt 0 ]; then
  printf "  %sUpdates:%s %s\n" "$GREEN" "$RESET" "$updates"
fi
if [ "$forgot" -gt 0 ]; then
  printf "  %sForgets:%s %s\n" "$YELLOW" "$RESET" "$forgot"
fi
if [ "$skipped" -gt 0 ]; then
  printf "  %sSkipped:%s %s\n" "$BLUE" "$RESET" "$skipped"
fi
if [ "$errors" -gt 0 ]; then
  printf "  %sErrors:%s %s\n" "$RED" "$RESET" "$errors"
fi

echo "Done!"
echo "Summary: updates=${updates}, forgot=${forgot}, skipped=${skipped}, errors=${errors}"
if [ "$QUICK_YES" -eq 1 ]; then
  echo "Note: operations were run non-interactively (via --add or --yes)."
fi
