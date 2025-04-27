#!/usr/bin/env bash

# constants
script_dir=$(readlink -f "$0" | xargs dirname)
cd "$script_dir" || exit 1

source_dir="src"
output_dir="out"

config="config.yaml"
metadata="metadata.yaml"

cover_page_file="$source_dir/cover.md"

# missing file checks
if [ ! -f "$metadata" ]; then
    echo "missing $metadata" >&2
fi

if [ ! -f "$config" ]; then
    echo "missing $config" >&2
fi

# retrieves key from config or prints missing key error
getkey() {
    local key=$1
    local file=$2

    local type
    type=$(yq -r ".${key} | type" "$file")

    case "$type" in
        array)
            mapfile -t _getkey_result < <(yq -r ".${key}[]" "$file" | grep -v null)
            ;;
        null)
            _getkey_result=()
            ;;
        *) # scalar (string, bool, number, etc.)
            _getkey_result=()
            _getkey_result+=("$(yq -r ".${key}" "$file")")
            ;;
    esac
}

# output filename
getkey output_filename "$config"
output_filename="${_getkey_result[0]}"

if [ -z "$output_filename" ]; then
    echo "output_filename is empty" >&2
    exit 1
fi

output="$output_dir/$output_filename"

# cover page
getkey cover_page "$config"
cover_page_key="${_getkey_result[0]}"
case "$cover_page_key" in
    true)
        cover_page="$cover_page_file"
        ;;
    false)
        cover_page=""
        ;;
    *)
        echo "cover_page has unexpected value: $cover_page_key" >&2
        ;;
esac

# sources
getkey 'sources' "$config"
listed_sources=("${_getkey_result[@]}")

# append src dir to listed sources and check missing sources
for i in "${!listed_sources[@]}"; do
    src="$source_dir/${listed_sources[$i]}"
    listed_sources[i]="$src"

    if [ ! -f "$src" ]; then
        echo "missing listed source '$src'" >&2
        exit 1
    fi
done

listed_sources=("$cover_page" "${listed_sources[@]}")

# include all
getkey include_all_sources "$config"
include_all_sources_key="${_getkey_result[0]}"

case "$include_all_sources_key" in
    true)
        all_sources=$(find "$source_dir" -name '*.md')

        declare -A listed_sources_set
        for src in "${listed_sources[@]}"; do
            listed_sources_set["$src"]=1
        done

        for src in $all_sources; do
            if  [[ -z "${listed_sources_set["$src"]}" ]]; then
                listed_sources+=("$src")
            fi
        done
        ;;
    false)
        ;;
    *)
        echo "include_all_sources has unexpected value: $include_all_sources_key" >&2
        ;;
esac

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
fi

if [[ ${#listed_sources[@]} -eq 0 && -z "$cover_page" ]]; then
    echo "nothing to do" >&2
    exit 1
fi

echo "compiling sources:"
echo  "${listed_sources[@]}"
pandoc --metadata-file="$metadata" "${listed_sources[@]}" -o "$output"
