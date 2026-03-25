#!/bin/bash

input="gsxtrack.json"
output="titik-penting.txt"

awk '
/"id":/ {
    gsub(/[",]/, "", $2)
    id=$2
}
/"site_name":/ {
    sub(/^[ \t]*"site_name": "/, "")
    sub(/",?$/, "")
    name=$0
}
/"latitude":/ {
    gsub(/[",]/, "", $2)
    lat=$2
}
/"longitude":/ {
    gsub(/[",]/, "", $2)
    lon=$2
    print id "," name "," lat "," lon
}
' "$input" > "$output"

echo "Data titik lokasi berhasil disimpan ke $output"
