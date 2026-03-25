#!/usr/bin/awk -f

BEGIN {
    FS=","
    # Ambil argumen terakhir sebagai mode
    mode = ARGV[ARGC-1]

    # Kurangi jumlah argumen supaya awk tidak baca "a" sebagai file
    ARGC--

    # print "DEBUG MODE =", mode
}

NR == 1 { next }

{
    count_passenger++

    carriage[$4] = 1

    if ($2 > max_age) {
        max_age = $2
        oldest = $1
    }

    total_age += $2

    if ($3 == "Business") {
        business_passenger++
    }
}

END {
    
    if (mode == "a") {
        print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang"
    }
    else if (mode == "b") {
        count_carriage = 0
        for (c in carriage) count_carriage++
        print "Jumlah gerbong penumpang KANJ adalah " count_carriage
    }
    else if (mode == "c") {
        print oldest " adalah penumpang kereta tertua dengan usia " max_age " tahun"
    }
    else if (mode == "d") {
        average = int(total_age / count_passenger)
        print "Rata-rata usia penumpang adalah " average " tahun"
    }
    else if (mode == "e") {
        print "Jumlah penumpang business class ada " business_passenger " orang"
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
}
