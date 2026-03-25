#!/bin/bash

file="titik-penting.txt"
hasil="posisipusaka.txt"

# Ambil titik pertama
first=$(head -n 1 "$file")

# Ambil titik terakhir
last=$(tail -n 1 "$file")

# Ambil latitude & longitude
lat1=$(echo "$first" | awk -F, '{print $3}')
lon1=$(echo "$first" | awk -F, '{print $4}')

lat2=$(echo "$last" | awk -F, '{print $3}')
lon2=$(echo "$last" | awk -F, '{print $4}')

# Hitung titik tengah + format desimal
mid_lat=$(awk "BEGIN {printf \"%.5f\", ($lat1 + $lat2)/2}")
mid_lon=$(awk "BEGIN {printf \"%.2f\", ($lon1 + $lon2)/2}")

# Output + simpan ke file
{
    echo "Koordinat pusat:"
    echo "$mid_lat, $mid_lon"
} | tee "$hasil"
