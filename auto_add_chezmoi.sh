#!/bin/bash

# Run chezmoi status and store the output
status_output=$(chezmoi status)

# Extract all files where the destination state indicates the destination has
# an added or modified file (including untracked). The output of `chezmoi status`
# prints the source/dest state as the first two characters, so check the second
# character and print the path starting in column 4 (so spaces in filenames are kept).
files_to_add=$(printf "%s\n" "$status_output" | awk '{st=substr($0,1,2); dest=substr(st,2,1); if(dest ~ /[AM?]/) print substr($0,4)}')

# If no changes are found, print a message and exit the script
if [ -z "$(printf '%s' "$files_to_add")" ]; then
  echo "No changes found to add."
  exit 0
fi

# Iterate lines safely (handles filenames with spaces)
printf '%s\n' "$files_to_add" | while IFS= read -r file; do
  [ -z "$file" ] && continue
  echo "Adding: $file"

  # Determine the absolute path to pass to `chezmoi add`.
  if [[ "$file" = /* ]]; then
    target="$file"
  else
    target="$HOME/$file"
  fi

  # Skip if the target doesn't exist, to avoid chezmoi lstat errors
  if [ ! -e "$target" ]; then
    echo "Warning: target does not exist, skipping: $target"
    continue
  fi

  if ! chezmoi add "$target"; then
    echo "Error: failed to add $target; skipping"
    continue
  fi
done

echo "Done! All changes have been added."
