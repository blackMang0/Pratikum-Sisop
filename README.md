# SISOP-1-2026-IT-067
## Soal 1
### Deskripsi
Terdapat sebuah data penumpang *passenger.csv*, Kita diminta untuk menganalisis data tersebut menggunakan command linux dan awk dengan mencari suatu nilai dari data file tersebut seperti:
* **Jumlah seluruh penumpang**
* **Jumlah gerbong**
* **Penumpang tertua**
* **Rata-rata usia penumpang**
* **Jumlah penumpang kelas bisnis**
### Penjelasan
Sebelum masuk ke penjelasan berikut adalah script dari file *KANJ.sh* 
```bash
#!/usr/bin/awk -f

BEGIN {
    FS=","
    # Ambil argumen terakhir sebagai mode
    mode = ARGV[ARGC-1]

    # Kurangi jumlah argumen supaya awk tidak baca "a" sebagai file
    ARGC--
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
```
#### A. Jumlah seluruh penumpang
Jumlah seluruh penumpang dapat dihitung menggunakan perintah awk, pada script diatas saya menambahkan shebang awk karena nanti file *KANJ.sh* akan dijalankan menggunakan awk, seperti ini
```bash
awk -f KANJ.sh passenger.csv a
```
pada command tersebut harus ada argumen yang akan digunakan untuk mencari salah satu nilai yang diperlukan argumen yang tersedia yaitu a/b/c/d/e.
Saya menambahkan *mode = ARGV[ARGC-1]* agar program mengambil *a/b/c/d/e* sebagai argumen dan bukan sebagai file karena jika tidak ada *ARGV[ARGC-1]* akan ada error seperti berikut  

<img width="954" height="74" alt="Screenshot 2026-03-29 215119" src="https://github.com/user-attachments/assets/43474466-8711-485e-a6c4-0df4adea219c" />

lalu *NR == 1 {next}* digunakan agar awk nantinya hanya membaca bagian isi filenya tidak perlu membaca header.
Jumlah seluruh penumpang dihitung pada bagian ini
```bash 
 count_passenger++
```
Jadi, awk akan membaca setiap baris dan jumlah baris tersebut akan terus bertambah sampai baris habis lalu, outputnya akan ditampiilkan pada bagian berikut
```bash
 if (mode == "a") {
        print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang"
    }
```
#### B. Jumlah gerbong penumpang
Script untuk menghitung jumlah gerbong penumpang sebagai berikut
```bash
carriage[$4] = 1
```
Carriage akan menyimpan setiap gerbong yang muncul pada kolom ke-4 ($4), jika gerbong sudah ada maka tidak akan melakukan apa-apa, sedangkan jika gerbong baru, maka akan disimpan dalam carriage dan seluruh gerbong akan ditampilkan pada script berikut menggunakan for loop
```bash
else if (mode == "b") {
        count_carriage = 0
        for (c in carriage) count_carriage++
        print "Jumlah gerbong penumpang KANJ adalah " count_carriage
    }
```
Loop tersebut adalah untuk menghitung berapa banyak gerbong unik yang ada, jika ada gerbong unik maka *count_carriage akan bertambah
#### C. Usia tertua penumpang
Dihitung dengan mencari max pada kolom usia penumpang, jika kolom 2 pada baris pertama dicek ternyata masih belum tertinggi maka awk akan terus mengecek setiap baris sampai nilai pada kolom 2 menjadi nilai tertinggi
```bash
 if ($2 > max_age) {
        max_age = $2
        oldest = $1
    }
```
#### D. Rata-rata usia penumpang
Rata-rata dihitung dengan menambah usia pada setiap baris lalu dibagi dengan *count_passenger* yang dihitung diawal tadi
```bash
 total_age += $2
```
dan ini
```bash
 average = int(total_age / count_passenger)
```
#### E. Jumlah penumpang kelas bisnis
Cara mencarinya yaitu dengan mengecek pada kolom ke-3 ($3) apakah stringnya sama dengan "Business", jika sama maka *business_passenger)* akan bertambah
```bash
if ($3 == "Business") {
        business_passenger++
    }
```
Pada bagian akhir program terdapat antisipasi yang tersedia jika user salah memasukkan argumen
```bash
else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
```
<img width="960" height="88" alt="Screenshot 2026-03-29 221957" src="https://github.com/user-attachments/assets/18fe8e4b-99bf-4014-bc75-e814cc57b522" />

## Soal 2
### Deskripsi
Terdapat seseorang yang ingin mencari titik tengah dari 4 koordinat. 4 koordinat tersebut dapat didapatkan lewat link repository github yang diberikan, sebelum mendapatkan link github, Pada soal diminta untuk mendownload file pdf menggunakan command *gdown* yang harus diinstall dulu packagenya
### Penjelasan
Download terlebih dahulu package gdown dengan command seperti berikut, sebelum itu diharapkan untuk mengupdate repository
```bash
sudo apt update && sudo apt upgrade -y
```
setelah itu install python atau pip terlebih dahulu jika belum ada
```bash
sudo apt install python3-pip -y
```
setelah pip berhasil terinstall barulah kita dapat mendownload package gdown
```bash
pip3 install gdown
```
Jika gdown sudah terinstall maka langkah selanjutnya yaitu mendownload file pdf *peta-ekspedisi-amba.pdf* pada link yang diberikan https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q dengan cara seperti ini, sebelum itu buat folder ekspedisi terlebih dahulu untuk menyimpan file pdf unduhan gdown nantinya dengan command *mkdir ekspedisi*
```bash
gdown https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q
```
Setelah file pdf terdownload, saya penasaran untuk membukanya dengan command *cat*(concatenate) yaitu untuk menampilkan isi dalam suatu file
```bash
cat peta-ekspedisi-amba.pdf
```
Ternyata file tersebut berisi string-string yang tidak dimengerti oleh komputer, tampilannya akan seperti ini

<img width="1460" height="323" alt="Screenshot 2026-03-29 223920" src="https://github.com/user-attachments/assets/78181926-994d-4b78-8395-a8c24b233af7" />

Namun, pada akhir isi file tersebut ada sebuah link github yang perlu di clone repositorynya

<img width="1106" height="348" alt="Screenshot 2026-03-29 224154" src="https://github.com/user-attachments/assets/b6b77a67-d17a-456d-92cb-9adcdd39bf0a" />

cara clone repository github yaitu dengan command *git clone* lalu diikuti dengan link github
```bash
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
```
Didalam repository tersebut terdapat file json yang berisi 4 titik koordinat, namun isi file tersebut masih terlalu membingungkan untuk dibaca oleh karena itu, pada soal diminta untuk membuat bash script "parserkoordinat.sh" untuk menampilkan longitude dan latitude pada file json tersebut dan output dari script disimpan dalam file "titik-penting.txt"

Sehingga dibuatlah file "parserkoordinat.sh" yang berisi sebagai berikut
```bash
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
```
Untuk dapat menemukan longitude dan latitude digunakanlah command awk, sebelum itu perlu menyimpan id dan juga site name, jika awk menemukan id */"id":/*, karakter-karakter yang tidak diperlukan akan dihapus pada *gsub(/[",]/, "", $2)* lalu id akan disimpan ke dalam variabel "id"
fungsi gsub dan sub pada command awk diatas yaitu untuk menghapus karakter/simbol yang tidak diperlukan, gsub untuk menghapus banyak karakter sedangkan sub untuk menghapus bagian tertentu

Dari command diatas yang dapat dijalankan seperti ini

<img width="1240" height="58" alt="Screenshot 2026-03-29 225619" src="https://github.com/user-attachments/assets/fd36a977-0cc4-4260-a057-87845083142e" />

Didapatkanlah nilai latitude dan longitude yang tercetak rapi tanpa ada banyak karakter mengganggu yang disimpan ke dalam file "titik-penting.txt".
Jika file "titik-penting.txt" dibuka maka akan terdapat output sebagai berikut

<img width="1273" height="144" alt="Screenshot 2026-03-29 225849" src="https://github.com/user-attachments/assets/8b93b606-2adb-437e-92ce-0c78214c6d4a" />

Setelah merapikan isi file json, sekarang tinggal mencari titik tengah dari keempat titik koordinat dengan bash script dengan nama file "nemupusaka.sh" dan isi dari output disimpan ke dalam file "posisipusaka.txt"
Isi dari file "nemupusaka.sh" sebagai berikut 
```bash
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
```
Awal mulanya program akan mengambil titik pertama dan titik terakhir terlebih dahulu menggunakan head dan tail yang diambil dari file "titik-penting.txt" lalu disimpan ke variabel first dan last, setelah itu program mengambil latitude1, longitude1, latitude2, dan longitude3 menggunakan command awk setelah ditampilkan menggunakan echo
Setelah itu barulah titik tengah dihitung menggunakan longitude dan latitude yang sudah didapatkan 
```bash
# Hitung titik tengah + format desimal
mid_lat=$(awk "BEGIN {printf \"%.5f\", ($lat1 + $lat2)/2}")
mid_lon=$(awk "BEGIN {printf \"%.2f\", ($lon1 + $lon2)/2}")
```
lalu tinggal dioutputkan dan disimpan ke dalam file "posisipusaka.txt"
```bash
{
    echo "Koordinat pusat:"
    echo "$mid_lat, $mid_lon"
} | tee "$hasil"
```
Berikut adalah tampilan jika program "nemupusaka.sh" dijalankan

<img width="1261" height="92" alt="Screenshot 2026-03-29 230751" src="https://github.com/user-attachments/assets/1791b313-558c-4d3a-8126-eee8d0df7f95" />

dan isi dari file "posisipusaka.txt" akan sama seperti diatas

## Soal 3
### Deskripsi
Membuat program bash script untuk mengelola data penghuni kost yang mencakup fungsi-fungsi berikut
* **Tambah penghuni baru**
* **Hapus penghuni**
* **Tampilkan daftar penghuni**
* **Update status penghuni**
* **Cetak laporan keuangan**
* **Kelola cron (pengingat tagihan)**
* **Exit**
Setiap bagian penting dari data yang disimpan dalam program tersebut akan diarahkan ke file-file yang berbeda, berikut adalah ketentuan lokasi file data tersebut
* **Folder data, berisi database penghuni-penghuni baru atau lama, "penghuni.csv"
* **Folder log, berisi log cron, tagihan yang menunggak "tagihan.log"
* **Folder rekap, berisi laporan bulanan untuk penghuni yang sudah membayar atau masih menunggak "laporan_bulanan.txt"
* **Folder sampah, berisi data penguni yang pernah dihapus "history_hapus.csv"
Fokus utama dalam program ini yaitu untuk memperdalam pengetahuan mengenai bash script yang akan mengimplementasikan if-else, loop, hubungan dengan file-file luar, dan lain sebagainya, dan tentang penggunaan cronjob

### Penjelasan
Berikut adalah isi dari file "kost_slebew.sh" yang dipisah sesuai dengan fungsinya masing-masing
```bash
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
```
Script diatas adalah untuk membuat folder/file-file baru yang akan digunakan untuk menyimpan data-data penting program, di dalam program juga terdapat antisipasi jika file sudah ada atau belum ada

```bash
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
```
Sedangkan script diatas digunakan untuk membuat program menjadi lebih interaktif dan untuk mengecek kondisi-kondisi yang memungkinkan, seperti jika tanggal yang dimasukkan adalah masa depan, kamar yang sama, penulisan status yang harus benar, dll

Lanjut, berikutnya adalah fungsi pertama pada program yaitu menambah penghuni baru
```bash
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
```
Diatas juga sudah terdapat antisipasi user jika user salah memasukkan input

Berikut adalah tampilan program utama

<img width="845" height="412" alt="Screenshot 2026-03-29 233016" src="https://github.com/user-attachments/assets/11fbe352-292e-4471-88d4-a35d801176a4" />

dan ini adalah gambaran dari fungsi pertama

<img width="757" height="493" alt="Screenshot 2026-03-29 233117" src="https://github.com/user-attachments/assets/28827b10-2c7c-4c2f-a2da-c9924624b288" />

Lalu ini adalah fungsi yang kedua yaitu untuk menghapus penghuni

```bash
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
```
Cara program menghapus penghuni adalah dengan mencari nama menggunakan command grep, data yang dihapus akan masuk ke sampah folder

Ini adalah tampilan menghapus penghuni

<img width="607" height="175" alt="Screenshot 2026-03-29 233540" src="https://github.com/user-attachments/assets/ce908d81-fcea-4ce2-a6cf-76f523e0b2fe" />

Fungsi yang ketiga yaitu untuk menampiikan penghuni yang ada, berikut scriptnya

```bash
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
```
Menggunakan *printf "%-3s %-15s %-8s %-12s %-10s\n",* agar tampilan penghuni terlihat lebih rapi
Berikut tampilan program tersebut

<img width="644" height="250" alt="Screenshot 2026-03-29 233843" src="https://github.com/user-attachments/assets/3624c980-aa0d-4ff0-9bc3-e75d046a52e8" />

Fungsi yang keempat adalah untuk mengupdate status penghuni kost

```bash
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
```
Dengan memasukkan nama dan status yang ingin diubah, user dapat mengupdate status penghuni

Lalu, Fungsi yang kelima yaitu laporan keuangan yang akan disimpan di folder rekap

```bash
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
```
Berisi total penghuni aktif dan menunggak, jumlah kamar, pemasukan, tunggakan, dan jumlah kamar yang terisi, dan setiap laporan akan disimpan di file "laporan_bulanan.txt"
Berikut tampilan program diatas

<img width="1305" height="94" alt="Screenshot 2026-03-29 234314" src="https://github.com/user-attachments/assets/86945a36-4917-4e8c-8643-eb411552db0f" />

Isi program langsung disimpan dalam file

<img width="1078" height="212" alt="Screenshot 2026-03-29 234409" src="https://github.com/user-attachments/assets/6d47447d-8475-4e1b-b571-ca192ad30889" />

Fungsi yang keenam adalah mengelola cron atau pengingat tagihan
```bash
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
```
Yang didalam fungsi tersebut masih ada menu lagi yaitu menu untuk menambah cron, melihat cron yang aktif dan menghapus cron 

<img width="1236" height="461" alt="Screenshot 2026-03-29 234717" src="https://github.com/user-attachments/assets/b4535c08-fa0c-41ff-ae41-d626b23752e0" />

Lalu untuk fungsi terakhir yaitu untuk check tagihan
```bash
check_tagihan(){

    while IFS=',' read nama kamar harga tanggal status
    do
        if [ "$status" == "Menunggak" ]; then

            echo "[$(date '+%Y-%m-%d %H:%M:%S')] TAGIHAN: $nama (Kamar $kamar) - Menunggak Rp$harga" >> "$LOG_FILE"

        fi
    done < <(tail -n +2 "$DB_FILE")
}
```
dan akan berjalan jika dipanggil seperti ini *./kost_slebew --check-tagihan* dan akan disimpan ke dalam file "tagihan.log"
Namun masih terdapat kesalahan pada program sehingga "tagihan.log" malah akan berisi kosong

