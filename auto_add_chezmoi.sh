#!/bin/bash

# Run chezmoi status and store the output
status_output=$(chezmoi status)

# Extract all files with the "MM" status (second column is the path)
# Use awk to match lines starting with MM and print the path (second field)
files_to_add=$(printf "%s\n" "$status_output" | awk '/^MM[[:space:]]/{print $2}')

# If no changes are found, print a message and exit the script
if [ -z "$(printf '%s' "$files_to_add")" ]; then
  echo "No changes found to add."
  exit 0
fi

# Iterate lines safely (handles filenames with spaces)
printf '%s\n' "$files_to_add" | while IFS= read -r file; do
  [ -z "$file" ] && continue
  echo "Adding: $file"

  # If the path is absolute, pass it directly to chezmoi
  if [[ "$file" = /* ]]; then
    chezmoi add "$file"
  else
    # For paths like ".config/..." or "config/...", add the HOME prefix
    chezmoi add "$HOME/$file"
  fi
done

echo "Done! All changes have been added."
