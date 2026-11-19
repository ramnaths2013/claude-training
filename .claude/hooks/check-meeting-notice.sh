#!/usr/bin/env bash
# PostToolUse guard: after Claude edits index.html, check the 10 second IT meeting popup.
# Exit 2 sends the problems back to Claude.
set -u

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import sys,json
try:
    d=json.load(sys.stdin); print((d.get("tool_input") or {}).get("file_path",""))
except Exception:
    print("")')"

target="${CHECK_FILE:-}"
if [ -z "$target" ]; then
  case "$file" in
    */index.html|index.html) target="$file" ;;
    *) exit 0 ;;
  esac
fi
[ -f "$target" ] || exit 0

problems=()
grep -q 'NOTICE_DELAY_MS = 10000' "$target" \
  || problems+=("The popup delay must be 10 seconds: NOTICE_DELAY_MS = 10000 is missing.")
grep -q 'setTimeout(tryShowNotice, NOTICE_DELAY_MS)' "$target" \
  || problems+=("The popup is not scheduled with setTimeout(tryShowNotice, NOTICE_DELAY_MS).")
grep -qE 'time: "10:00 am"' "$target" \
  || problems+=("Meeting time must be 10:00 am.")
grep -qE 'weekday: 3' "$target" \
  || problems+=("Meeting weekday must be Wednesday (weekday: 3).")
grep -q 'Room 888' "$target" \
  || problems+=("Meeting room must be Room 888.")
grep -q 'role="alertdialog"' "$target" \
  || problems+=("The popup must be an in-page dialog with role=\"alertdialog\".")
# Native alert() is not allowed (CLAUDE.md). Calls with an argument only, so comments are fine.
hits="$(grep -nE '(^|[^A-Za-z_.])alert\([^)]' "$target" | head -5)"
[ -z "$hits" ] || problems+=("Native alert() used, use the in-page dialog instead:"$'\n'"$hits")

if [ "${#problems[@]}" -gt 0 ]; then
  {
    echo "Meeting notice guard check failed:"
    for p in "${problems[@]}"; do echo " - $p"; done
  } >&2
  exit 2
fi
exit 0
