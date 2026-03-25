#!/bin/bash

BEGIN {
    FS = ","
}

NR > 1 && $0 !~ /^[[:space:]]*$/ {
    # a: Total Penumpang
    total++

    # b: Gerbong Unik (simpan di array)
    if ($4 != "") {
        gerbong[$4]++
    }

    # c: Penumpang Tertua
    if ($2 > max_usia) {
        max_usia = $2
        nama_tua = $1
    }

    # d: Rata-rata Umur (hitung total usia dulu)
    sum_usia += $2

    # e: Total Business
    if ($3 == "Business") {
        business_count++
    }
}

END {
    if (mode == "a") print "Total Penumpang: " total
    else if (mode == "b") print "Jumlah Gerbong Unik: " length(gerbong)
    else if (mode == "c") print "Penumpang Tertua: " nama_tua " (" max_usia " tahun)"
    else if (mode == "d") printf "Rata-rata Umur: %.2f tahun\n", sum_usia/total
    else if (mode == "e") print "Total Penumpang Business: " business_count
    else print "Argumen tidak dikenal! Gunakan a, b, c, d, atau e."
}
