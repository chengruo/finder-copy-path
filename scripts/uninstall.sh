#!/bin/zsh
set -euo pipefail

destination="${HOME}/Library/Services/Copy Absolute Path.workflow"

if [[ -d "$destination" ]]; then
  /bin/rm -rf "$destination"
  print "Removed: ${destination}"
else
  print "Not installed: ${destination}"
fi
