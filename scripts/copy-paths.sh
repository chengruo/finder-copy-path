#!/bin/zsh
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
printf '%s' "$clipboard_text"
