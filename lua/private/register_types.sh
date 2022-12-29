#!/usr/bin/bash

backup_folder="/tmp/files-backup-lua/$(date '+%Y_%m_%d__%T')"

basedname() {
    basename "$1" .lua
}

fmt() {
    stripped=$1
    echo "--- @class Priv$stripped"
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
    cp "$1" "$backup_folder/."
}

add_type() {
    local filename="$1"
    local stripped=$(basedname "$filename")

    if head -n 1 $filename | grep -x -- "$(fmt $stripped)" > /dev/null; then 
        return
    fi
    edit_file edit_module "$filename" "$stripped"
}

function edit_file() {
    local edit_fn="$1"
    local filename="$2"
    local stripped="$3"

    new_file=$(mktemp "/tmp/XXX-$stripped.lua")
    if [[ $? -ne 0 ]]; then
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

    echo '--- @class Priv' > "$new_init"
    for d in $(ls *.lua | grep -v init.lua); do
        add_type "$d" edit_module
        name="$(basedname $d)"
        echo "--- @field $name Priv$name" >> "$new_init"
    done
    echo "--- @field lspcfg Privlspcfg" >> "$new_init"
}

if ! mkdir -p "$backup_folder" && test -d "$backup_folder" ; then
    exit -1
fi

backup init.lua &&
edit_file edit_init init.lua init
