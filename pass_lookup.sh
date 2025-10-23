#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Default settings
output_encoding="utf-8"
hibp_sha1_dir="${HIBP_SHA1_DIR:-hibp_sha1_dir}"  # Can override with env var

# Check for required tools
for cmd in file iconv sha1sum rg; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' not found" >&2
        exit 2
    fi
done

# Validate arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $(basename "$0") <password> [debug]" >&2
    exit 2
fi

input_str="$1"
debug_mode=0
[[ ${2:-} == "debug" ]] && debug_mode=1

# Validate HIBP directory exists
if [[ ! -d "$hibp_sha1_dir" ]]; then
    echo "Error: HIBP SHA1 directory '$hibp_sha1_dir' not found" >&2
    exit 2
fi

# detect da input encoding
input_encoding="$(echo -n "$input_str" | file -i - | awk -F'charset=' '{print $2}' || echo 'utf-8')"
[[ -z "$input_encoding" ]] && input_encoding="utf-8"

# convert da silly into utf-8
converted_str=$(iconv -f "$input_encoding" -t "$output_encoding" <<< "$input_str" 2>/dev/null || echo "$input_str")

# convert da silly into sha1
sha1_str=$(echo "$converted_str" | sha1sum | awk '{print $1}' | tr 'a-z' 'A-Z')

# get da first five chars
first_five="${sha1_str:0:5}"

# lookup da hash in hibp sha1 dir
lookup_file="$hibp_sha1_dir/$first_five.txt"

if ((debug_mode)); then
    echo "input_str (\$1): $input_str"
    echo "hibp_sha1_dir: $hibp_sha1_dir"
    echo "output_encoding: $output_encoding"
    echo "input_encoding: $input_encoding"
    echo "converted_str: $converted_str"
    echo "sha1_str: $sha1_str"
    echo "first_five: $first_five"
    echo "lookup_file: $lookup_file"
fi

# Check if lookup file exists
if [[ ! -f "$lookup_file" ]]; then
    echo "Hash prefix $first_five not found in database" >&2
    exit 1
fi

# Look up the hash (ripgrep returns 0 if found, 1 if not found)
if rg --quiet --fixed-strings "$sha1_str" "$lookup_file" 2>/dev/null; then
    echo "Password found in breaches"
    exit 0
else
    echo "Password not found in breaches"
    exit 1
fi