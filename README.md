# tribun_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


note: 

REST: Representational State Transfer
API: Application Programming Interface 

REST dan API: 
1. komunikasi dan pertukaran data
2. HTTP (hypertext transfer protokol) untuk transfer data

->menerima http request dari klayen ->get, post, update, delete
->pemrosesan server (sesuai metode dan endpoint)
->generasi responts(status http dan data)
->penerimaan kliyen

contoh dari 4 ini yaitu : request (user)->rest API-> server(si API dia nanya sama si server ini udh bagus blm)->http status 200 ok->rest API(disini dia langsung ke API soalnya kata si server udh bagus)->cliyen menerima

folder controllers buat ngeget
models buat model data
screens buat halaman UI
services buat service API
utils buat tema
widgets buat naro image dll
bindings buat depedency injection
routes buat routing aplikasinya
main.dart buat enter point aplikasi


langkah2 untuk mengkofigurasi API:
1. Mendapatkan API
2. Buat file.env di dalma route Masukan API yang sudah di dapatkan ke dalam sebuah variable yang bernama API_KEY
3. Daftarkan file .env ke dalam file pubspec.yaml di dalam tag assets
4. Daftarkan file .env ke dalam file .gitignore agar file .env tidak ikut terbawa ke stage remote ketika projek dilakukan proses git push


tipe data json merupakan tipe data uyang di dalemnya map
yang akan dikembalikan oleh API atau server ketika kita melakukan atau membuat sebuah requaest, diantaranya:

 1. status HTTP
 2. DATA YANG BERFORMAT JSON