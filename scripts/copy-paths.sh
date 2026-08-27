#!/bin/zsh

# Automator passes Finder selections as individual arguments. Each path is
# wrapped in double quotes for readable terminal use. Characters that retain
# special meaning inside double quotes are escaped first.
(( $# > 0 )) || exit 0

clipboard_text=''
for selected_path in "$@"; do
  escaped_path="${selected_path//\\/\\\\}"
  escaped_path="${escaped_path//\"/\\\"}"
  escaped_path="${escaped_path//\$/\\\$}"
  escaped_path="${escaped_path//\`/\\\`}"
  [[ -z "$clipboard_text" ]] || clipboard_text+=' '
  clipboard_text+='"'"$escaped_path"'"'
done

pbcopy_command="${COPY_PATH_PBCOPY:-/usr/bin/pbcopy}"
printf '%s' "$clipboard_text" | "$pbcopy_command"
