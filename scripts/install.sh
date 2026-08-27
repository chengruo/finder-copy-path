#!/bin/zsh
set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
workflow_name="Copy Absolute Path.workflow"
services_dir="${HOME}/Library/Services"
destination="${services_dir}/${workflow_name}"

/bin/mkdir -p "$services_dir"
/bin/rm -rf "$destination"
/bin/cp -R "${project_dir}/${workflow_name}" "$destination"

# Refresh the per-user Services menu cache. LaunchServices alone does not add
# Automator workflows to Finder's Quick Actions menu.
/System/Library/CoreServices/pbs -update >/dev/null 2>&1 || true

print "Installed: ${destination}"
print "In Finder, right-click an item and choose Quick Actions → Copy Absolute Path."
