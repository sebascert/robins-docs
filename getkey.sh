#!/usr/bin/env bash

# Retrieves key from config or prints error

set -euo pipefail
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND" >&2' ERR

usage(){
    echo "Usage: getkey.sh <optional|mandatory> KEY FILE TYPE"
    echo "Valid types:"
    echo "    bool"
    echo "    number"
    echo "    string"
    echo "    array"
}

[ $# -eq 4 ] || {
    usage
    exit 1
} >&2

optional_str=$1
expected_type=$2
key=$3
file=$4

case "$optional_str" in
    optional) optional=0 ;;
    mandatory) optional=1 ;;
    *)
        {
            echo "GetKey Error: invalid optional arg '$optional_str'"
        } >&2
        exit 1
        ;;
esac

type=$(yq -r ".${key} | type" "$file")

# Handle missing key
if [ "$type" == "null" ]; then
    [ $optional -eq 0 ] || {
        echo "Config Error: missing mandatory key '$key'"
        exit 1
    } >&2
    exit 0
fi

# Type check and output
case "$expected_type" in
    bool)
        [ "$type" == "boolean" ] || {
            echo "Config Error: key '$key' is expected to be a boolean"
            echo "Recieved type: '$type'"
            exit 1
        } >&2
        if [ "$(yq -r ".${key}" "$file")" == "false" ];then
            echo 0
        else
            echo 1
        fi
        ;;
    number)
        [ "$type" == "number" ] || {
            echo "Config Error: key '$key' is expected to be a number"
            echo "Recieved type: '$type'"
            exit 1
        } >&2
        yq -r ".${key}" "$file"
        ;;
    string)
        [ "$type" == "string" ] || {
            echo "Config Error: key '$key' is expected to be a string"
            echo "Recieved type: '$type'"
            exit 1
        } >&2
        yq -r ".${key}" "$file"
        ;;
    array)
        [ "$type" == "array" ] || {
            echo "Config Error: key '$key' is expected to be an array"
            echo "Recieved type: '$type'"
            exit 1
        } >&2
        # Output elements separated by nulls for safe reading
        # usage: mapfile -d '' -t arr < <(./getkey.sh ...)
        yq -r ".${key}[]" "$file" | tr '\n' '\0'
        ;;
    *)
        {
            echo "GetKey Error: invalid type arg '$type'"
        } >&2
        exit 1
        ;;
esac

exit 0
