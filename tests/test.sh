#!/bin/zsh
set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
workflow="${project_dir}/Copy Absolute Path.workflow/Contents/Resources/document.wflow"

/usr/bin/plutil -lint "$workflow"
/usr/bin/plutil -lint "${project_dir}/Copy Absolute Path.workflow/Contents/Info.plist"

service_message=$(/usr/libexec/PlistBuddy -c \
  'Print :NSServices:0:NSMessage' \
  "${project_dir}/Copy Absolute Path.workflow/Contents/Info.plist")
[[ "$service_message" == 'runWorkflowAsService' ]] || {
  print -u2 "The workflow does not declare a macOS service entry point."
  exit 1
}

workflow_type=$(/usr/libexec/PlistBuddy -c \
  'Print :workflowMetaData:workflowTypeIdentifier' "$workflow")
[[ "$workflow_type" == 'com.apple.Automator.servicesMenu' ]] || {
  print -u2 "The workflow metadata is not marked as a Services menu workflow."
  exit 1
}

workflow_script=$(/usr/libexec/PlistBuddy -c \
  'Print :actions:0:action:ActionParameters:COMMAND_STRING' "$workflow")
expected_script=$(/bin/cat "${project_dir}/scripts/copy-paths.sh")

[[ "$workflow_script" == "$expected_script" ]] || {
  print -u2 "The script embedded in document.wflow is out of date."
  exit 1
}

capture_file=$(/usr/bin/mktemp "${TMPDIR:-/tmp}/copy-path-test.XXXXXX")
cleanup() { /bin/rm -f "$capture_file"; }
trap cleanup EXIT

COPY_PATH_TEST_OUTPUT="$capture_file" \
COPY_PATH_PBCOPY="${project_dir}/tests/capture-stdin.sh" \
  "${project_dir}/scripts/copy-paths.sh" \
  '/tmp/a file.txt' '/tmp/it'\''s "$HOME" `file`.txt' \
  '/tmp/目录/文件.txt' '/tmp/-leading-dash'

actual=$(/bin/cat "$capture_file")
expected=$'"/tmp/a file.txt"\n"/tmp/it\'s \\"\\$HOME\\" \\`file\\`.txt"\n"/tmp/目录/文件.txt"\n"/tmp/-leading-dash"'
[[ "$actual" == "$expected" ]] || {
  print -u2 "Clipboard output did not match."
  exit 1
}

print "All tests passed."
