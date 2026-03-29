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










