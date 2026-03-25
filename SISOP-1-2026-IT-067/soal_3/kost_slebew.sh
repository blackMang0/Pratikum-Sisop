#!/bin/bash

# ==============================
# KONFIGURASI FILE
# ==============================
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

DATA_DIR="$BASE_DIR/data"
LOG_DIR="$BASE_DIR/log"
REKAP_DIR="$BASE_DIR/rekap"
SAMPAH_DIR="$BASE_DIR/sampah"

DB_FILE="$DATA_DIR/penghuni.csv"
LOG_FILE="$LOG_DIR/tagihan.log"
LAPORAN_FILE="$REKAP_DIR/laporan_bulanan.txt"
HISTORY_FILE="$SAMPAH_DIR/history_hapus.csv"

mkdir -p "$DATA_DIR" "$LOG_DIR" "$REKAP_DIR" "$SAMPAH_DIR"

# buat file jika belum ada
touch "$DB_FILE" "$LOG_FILE" "$LAPORAN_FILE" "$HISTORY_FILE"

# header csv jika kosong
if [ ! -s "$DB_FILE" ]; then
    echo "nama,kamar,harga_sewa,tanggal_masuk,status" > "$DB_FILE"
fi

# ==============================
# FUNGSI BANTU
# ==============================

pause(){
    read -p "Tekan ENTER untuk kembali ke menu..."
}

valid_tanggal(){
    date -d "$1" +"%Y-%m-%d" >/dev/null 2>&1
}

tanggal_tidak_masa_depan(){
    today=$(date +%Y-%m-%d)
    [[ "$1" <="$today" ]]
}

kamar_unik(){
    grep -q ",$1," "$DB_FILE"
    if [ $? -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

status_valid(){
    case "${1,,}" in
        aktif|menunggak) return 0;;
        *) return 1;;
    esac
}

# ==============================
# FITUR 1 - TAMBAH PENGHUNI
# ==============================
tambah_penghuni(){

    echo "===== TAMBAH PENGHUNI ====="

    read -p "Masukkan Nama: " nama
    read -p "Masukkan Kamar: " kamar
    read -p "Masukkan Harga Sewa: " harga
    read -p "Masukkan Tanggal Masuk (YYYY-MM-DD): " tanggal
    read -p "Masukkan Status Awal (Aktif/Menunggak): " status

    # validasi
    if ! [[ "$harga" =~ ^[0-9]+$ ]]; then
        echo "Harga harus angka positif"
        pause
        return
    fi

    if ! valid_tanggal "$tanggal"; then
        echo "Format tanggal salah"
        pause
        return
    fi

    if ! tanggal_tidak_masa_depan "$tanggal"; then
        echo "Tanggal tidak boleh masa depan"
        pause
        return
    fi

    if ! kamar_unik "$kamar"; then
        echo "Nomor kamar sudah digunakan"
        pause
        return
    fi

    if ! status_valid "$status"; then
        echo "Status harus Aktif atau Menunggak"
        pause
        return
    fi

    status=$(echo "$status" | awk '{print tolower($0)}')
    status="$(tr '[:lower:]' '[:upper:]' <<< ${status:0:1})${status:1}"

    echo "$nama,$kamar,$harga,$tanggal,$status" >> "$DB_FILE"

    echo "[✓] Penghuni \"$nama\" berhasil ditambahkan ke kamar $kamar"
    pause
}

# ==============================
# FITUR 2 - HAPUS PENGHUNI
# ==============================
hapus_penghuni(){

    echo "===== HAPUS PENGHUNI ====="
    read -p "Masukkan nama penghuni: " nama

    data=$(grep "^$nama," "$DB_FILE")

    if [ -z "$data" ]; then
        echo "Penghuni tidak ditemukan"
        pause
        return
    fi

    tanggal_hapus=$(date +%Y-%m-%d)

    echo "$data,$tanggal_hapus" >> "$HISTORY_FILE"

    grep -v "^$nama," "$DB_FILE" > temp.csv
    mv temp.csv "$DB_FILE"

    echo "[✓] Data $nama dipindahkan ke history_hapus.csv"
    pause
}

# ==============================
# FITUR 3 - TAMPILKAN DATA
# ==============================
tampilkan_penghuni(){

    echo "===== DAFTAR PENGHUNI ====="

    awk -F',' '
    BEGIN{
        printf "%-3s %-15s %-8s %-12s %-10s\n",
        "No","Nama","Kamar","Harga","Status"
    }

    NR>1{
        printf "%-3d %-15s %-8s Rp%-11s %-10s\n",
        NR-1,$1,$2,$3,$5

        if($5=="Aktif") aktif++
        if($5=="Menunggak") tunggak++
    }

    END{
        print "------------------------------"
        printf "Aktif: %d | Menunggak: %d\n",
        aktif,tunggak
    }
    ' "$DB_FILE"

    pause
}

# ==============================
# FITUR 4 - UPDATE STATUS
# ==============================
update_status(){

    echo "===== UPDATE STATUS ====="

    read -p "Masukkan Nama: " nama
    read -p "Masukkan Status Baru (Aktif/Menunggak): " status

    if ! status_valid "$status"; then
        echo "Status tidak valid"
        pause
        return
    fi

    awk -F',' -v OFS=',' -v nama="$nama" -v status="$status" '
    {
        if($1==nama){
            $5=status
            found=1
        }
        print
    }

    END{
        if(found!=1){
            print "NOTFOUND" > "/dev/stderr"
        }
    }
    ' "$DB_FILE" > temp.csv

    if grep -q NOTFOUND temp.csv; then
        echo "Penghuni tidak ditemukan"
        rm temp.csv
    else
        mv temp.csv "$DB_FILE"
        echo "[✓] Status berhasil diupdate"
    fi

    pause
}

# ==============================
# FITUR 5 - LAPORAN KEUANGAN
# ==============================
laporan(){

    aktif_total=$(awk -F',' '$5=="Aktif"{sum+=$3} END{print sum+0}' "$DB_FILE")

    tunggak_total=$(awk -F',' '$5=="Menunggak"{sum+=$3} END{print sum+0}' "$DB_FILE")

    jumlah_kamar=$(($(wc -l < "$DB_FILE")-1))

    echo "===== LAPORAN =====" > "$LAPORAN_FILE"

    echo "Total pemasukan (Aktif): Rp$aktif_total" >> "$LAPORAN_FILE"
    echo "Total tunggakan: Rp$tunggak_total" >> "$LAPORAN_FILE"
    echo "Jumlah kamar terisi: $jumlah_kamar" >> "$LAPORAN_FILE"

    echo "" >> "$LAPORAN_FILE"
    echo "Daftar penghuni menunggak:" >> "$LAPORAN_FILE"

    awk -F',' '$5=="Menunggak"{print $1}' "$DB_FILE" >> "$LAPORAN_FILE"

    echo "[✓] Laporan disimpan di $LAPORAN_FILE"
    pause
}

# ==============================
# FITUR CRON CHECK TAGIHAN
# ==============================
check_tagihan(){

    while IFS=',' read nama kamar harga tanggal status
    do
        if [ "$status" == "Menunggak" ]; then

            echo "[$(date '+%Y-%m-%d %H:%M:%S')] TAGIHAN: $nama (Kamar $kamar) - Menunggak Rp$harga" >> "$LOG_FILE"

        fi
    done < <(tail -n +2 "$DB_FILE")
}

# ==============================
# FITUR 6 - KELOLA CRON
# ==============================
kelola_cron(){

while true
do

echo "===== MENU CRON ====="
echo "1. Lihat Cron Aktif"
echo "2. Daftarkan Cron"
echo "3. Hapus Cron"
echo "4. Kembali"

read -p "Pilih: " pilih

case $pilih in

1)

crontab -l 2>/dev/null | grep kost_slebew

pause
;;

2)

read -p "Jam (0-23): " jam
read -p "Menit (0-59): " menit

(crontab -l 2>/dev/null | grep -v kost_slebew
echo "$menit $jam * * * $BASE_DIR/kost_slebew.sh --check-tagihan") | crontab -

echo "[✓] Cron berhasil dibuat"

pause
;;

3)

crontab -l 2>/dev/null | grep -v kost_slebew | crontab -

echo "[✓] Cron berhasil dihapus"

pause
;;

4)
break
;;

*)
echo "Pilihan salah"
;;

esac

done
}

# ==============================
# MENU UTAMA
# ==============================

menu(){

while true
do

clear

echo "==============================="
echo "   SISTEM KOST SLEBEW"
echo "==============================="

echo "1. Tambah Penghuni"
echo "2. Hapus Penghuni"
echo "3. Tampilkan Penghuni"
echo "4. Update Status"
echo "5. Laporan Keuangan"
echo "6. Kelola Cron"
echo "7. Exit"

echo ""
read -p "Pilih [1-7]: " pilih

case $pilih in

1) tambah_penghuni ;;
2) hapus_penghuni ;;
3) tampilkan_penghuni ;;
4) update_status ;;
5) laporan ;;
6) kelola_cron ;;
7) exit ;;
*) echo "Pilihan salah"; sleep 1 ;;

esac

done
}

# ==============================
# ARGUMENT CRON
# ==============================

if [ "$1" == "--check-tagihan" ]; then
    check_tagihan
    exit
fi

menu
