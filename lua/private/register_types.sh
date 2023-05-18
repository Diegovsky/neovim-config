#!/usr/bin/bash
PREFIX=$(basename $PWD)
backup_folder="/tmp/files-backup-lua/$(date '+%Y_%m_%d__%T')"


PREFIX=${PREFIX^}

error() {
    echo -e "\033[31mError:\033[0m" "$@" 1>&2
}


basedname() {
    basename "$1" .lua
}

fmt() {
    stripped=$1
    echo "--- @class $PREFIX$stripped"
}

pad_type() {
    gawk '{ if (! found) {
        if($0 ~ /local M/) { found = 1; print }
        if($0 ~ /--- ?@(field|class)/) skip
        } else { print } }' "$1"
}

backup() {
    if [[ -z "$1" ]]; then
        echo 'Failed to backup, no file provided' 1>&2
        return -1
    fi
    mkdir -p "$backup_folder/$PREFIX/" &&
    cp "$1" "$backup_folder/$PREFIX/."
}

add_type() {
    local filename="$1"
    local stripped=$(basedname "$filename")

    if ! head -n 1 $filename | grep -- "--- *@class" > /dev/null; then 
        error "Failed to find type in $filename"
        return -1
    fi
    edit_file edit_module "$filename" "$stripped"
}

# Executes function `$1` on filename `$2`, with stripped name `$3`
# Before executing, it backs up the file
function edit_file() {
    local edit_fn="$1"
    local filename="$2"
    local stripped="$3"
    local new_file

    new_file=$(mktemp "/tmp/XXX-$stripped.lua")
    if [[ $? -ne 0 ]]; then
        error "Failed to create temporary file"
        return -1
    fi
    backup $filename &&
    $edit_fn "$new_file" "$stripped" &&
    pad_type "$filename" >> "$new_file" &&
    mv "$new_file" $filename
}

function edit_module() {
    local new_file="$1"
    local stripped="$2"
    fmt "$stripped" > "$new_file"
}

function edit_init() {
    local new_init="$1"
    local _stripped="$2"

    echo "--- @class $PREFIX" > "$new_init"
    for d in $(ls *.lua | grep -v init.lua); do
        add_type "$d"
        name="$(basedname $d)"
        echo "--- @field $name $PREFIX$name" >> "$new_init"
    done
    echo "--- @field lspcfg $PREFIX""lspcfg" >> "$new_init"
}

if ! mkdir -p "$backup_folder" && test -d "$backup_folder" ; then
    error "Failed to create backup folder"
    exit -1
fi

echo "Backing up files to '$backup_folder'"

backup init.lua &&
edit_file edit_init init.lua init
