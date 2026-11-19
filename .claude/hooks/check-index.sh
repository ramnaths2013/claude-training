#!/usr/bin/env bash
# PostToolUse guard: after Claude edits index.html, check the project rules from CLAUDE.md
# and the chatbot voice greeting. Exit 2 sends the problems back to Claude.
set -u

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import sys,json
try:
    d=json.load(sys.stdin); print((d.get("tool_input") or {}).get("file_path",""))
except Exception:
    print("")')"

# Only act on index.html (override path for testing with CHECK_FILE).
target="${CHECK_FILE:-}"
if [ -z "$target" ]; then
  case "$file" in
    */index.html|index.html) target="$file" ;;
    *) exit 0 ;;
  esac
fi
[ -f "$target" ] || exit 0

problems=()

# 1. Chatbot voice greeting must exist and be spoken with the Web Speech API.
grep -qF "I am your IT assistant, how can I help you?" "$target" \
  || problems+=("Voice greeting sentence 'I am your IT assistant, how can I help you?' is missing.")
grep -q "speechSynthesis" "$target" \
  || problems+=("speechSynthesis is not used, so the chatbot cannot speak the greeting.")

# 2. No storage APIs, no !important.
hits="$(grep -nE 'localStorage|sessionStorage|indexedDB|document\.cookie|!important' "$target" | head -5)"
[ -z "$hits" ] || problems+=("Forbidden storage API or !important:"$'\n'"$hits")

# 3. No external resources (src/href/url() to http or https).
hits="$(grep -nE '(src|href)=["'"'"']https?://|url\(["'"'"']?https?://|@import[^;]*https?://' "$target" | head -5)"
[ -z "$hits" ] || problems+=("External resource found:"$'\n'"$hits")

# 4. The only network call is the FormSubmit endpoint.
hits="$(grep -nE 'fetch\(' "$target" | grep -v 'FORMSUBMIT_ENDPOINT' | head -5)"
[ -z "$hits" ] || problems+=("fetch() used with something other than FORMSUBMIT_ENDPOINT:"$'\n'"$hits")

if [ "${#problems[@]}" -gt 0 ]; then
  {
    echo "index.html guard check failed:"
    for p in "${problems[@]}"; do echo " - $p"; done
  } >&2
  exit 2
fi
exit 0
