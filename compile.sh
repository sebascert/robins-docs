#!/usr/bin/env bash

# Compiles document with given configurations

set -euo pipefail

# constants
script_dir=$(readlink -f "$0" | xargs dirname)

cd "$script_dir" || {
    echo "Error: unable to enter scritp's parent directory"
    echo "Error: script dir: $script_dir"
    exit 1
} >&2

source_dir="src"
output_dir="out"

config="config.yaml"
metadata="metadata.yaml"

coverpage_path="$source_dir/cover.md"

# Missing file checks
[ -r "$metadata" ] || {
    echo "Error: unable to access $metadata"
    exit 1
} >&2

[ -r "$config" ] || {
    echo "Error: unable to access $config"
    exit 1
} >&2

# Retrieve configurations

# Output filename
output_filename=$(./getkey.sh mandatory string output_filename "$config") || exit 1
[ -z "$output_filename" ] && {
    echo "Error: output_filename is empty"
    exit 1
} >&2

# Cover page
coverpage_key=$(./getkey.sh mandatory bool cover_page "$config") || exit 1
if [ "$coverpage_key" -eq 1 ]; then
    [ -r "$coverpage_path" ] || {
        echo "Error: unable to access $coverpage_path"
        exit 1
    } >&2
    coverpage="$coverpage_path"
else
    coverpage=""
fi

# sources
if ./getkey.sh optional array sources "$config" | mapfile -d '' -t listed_sources; then
    :
else
    exit 1
fi

# Append source dir to listed sources
for i in "${!listed_sources[@]}"; do
    source="$source_dir/${listed_sources[$i]}"
    listed_sources[i]="$source"
done

# Validate listed sources
declare -A listed_sources_set
for source in "${listed_sources[@]}"; do
    [ -n "${listed_sources_set["$source"]-}" ] && {
        echo "Warning: repeated listed source '$source'"
        continue
    }
    [ -r "$source" ] || {
        echo "Warning: unable to access listed source '$source'"
        listed_sources_set["$source"]=1
        continue
    } >&2
    listed_sources_set["$source"]=0
done

# Include all sources
include_all_sources_key=$(./getkey.sh mandatory bool include_all_sources "$config") || exit 1
if [ "$include_all_sources_key" -eq 1 ]; then
    # shellcheck disable=SC2207
    listed_sources=($(find "$source_dir" -name '*.md' ! -path "$coverpage_path"))
else
    for source in "${listed_sources[@]}"; do
        [ "${listed_sources_set["$source"]}" -eq 0 ] || {
            echo "Error: unable to access listed source '$source'"
            exit 1
        } >&2
    done
fi

# Insert coverpage into listed sources
[ -n "$coverpage" ] && listed_sources=("$coverpage" "${listed_sources[@]}")

# Status feedback
[ "${#listed_sources[@]}" -eq 0 ] && {
    echo "nothing to do"
    exit 2
} >&2

{
    echo "compiling sources:"
    printf "%s\n" "${listed_sources[@]}"
} >&2

# Compile document
mkdir -p "$output_dir"

output="$output_dir/$output_filename"
pandoc --metadata-file="$metadata" "${listed_sources[@]}" -o "$output"
