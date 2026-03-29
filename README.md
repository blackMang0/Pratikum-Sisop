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






