

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/services/news_services.dart';
import 'package:tribun_app/utils/constants.dart';

class NewsController extends GetxController {
  // extends itu buat ngambil/mewarisi semua properti dan method dari class lain
  final NewsServices _newsServices =NewsServices();
  // untuk memproses request yang sudah di buat oleh news services
  
  // seter kek contohnya ada _ 
  // kalo seter dia private kalo getter dia publik
 // .obs itu observable(variable yang bisa berubah), jadi ini tuh buat ngecek apakah data sedang di load atau tidak (milik getx)
  final _isLoading = false.obs; //apakah aplikasi sedng memuat berita
  final _articles = <NewsArticles>[].obs; //ini untuk menampilkan daftar berita yang sudah/berhasil didapatkan
  // <NewsArticles>[] itu buat nampung data dari model news articles
  final _selectedCategory = 'general'.obs; //ini untuk menampung kategori berita yang sedang dipilih  atau yang akan muncul di homescreen
  final _error = ''.obs; //ini untuk menampung pesan error yang mungkin terjadi saat mengambil data dari server 

  // getters
  // getter ini, seperti jendela untuk melihat isi variable yang sudah di 
  //definisikan/dibuat tadi. dengan ini UI bisa mudah melihat data dari controller
  bool get isLoading => _isLoading.value;
  // getter untuk mengakses nilai dari _isLoading
  List<NewsArticles> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;
  // begitu aplikasi di buka, aplikasi langsung menampilkan berita utama dari top-headlines
  // TODO: fatching data dari endpoint top-headlines

  Future<void> fetchTopHeadlines({String? category}) async {
  // kenapa pake future karena ini bisa nunggu data dari server
  // blok ini akan di jalankan ketika res API berhasil komunikasi dengan server
   
      try {
        _isLoading.value = true;  // menandakan aplikasi sedang memuat berita
        _error.value = ''; // mengosongkan pesan error sebelum melakukan request baru

        final response = await _newsServices.getTopHeadLines(
          Category: category ?? _selectedCategory.value,
          // kalau category null maka dia bakal ambil dari selected category
          // kalau tidak null maka dia bakal ambil dari category yang di kirim
          // ini buat ngecek kalo misalnya user ganti kategori berita
          //  ?? fungsinya buat ngecek apakah category itu null atau tidak (default value)
          // default value itu nilai awal
        );
         _articles.value = response.articles; // menyimpan daftar berita yang didapatkan dari server
      } catch (e) {
        _error.value = e.toString(); // menyimpan pesan error jika terjadi kesalahan saat mengambil data itu biar ga eror string jadi langsung eror nya di ubah ke string
        Get.snackbar(
          'Error',
          'Failed to load news: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          ); // menampilkan pesan error ke user

          // finally akan tetap diexEcutE setelah salah satu dari blok try atau catch sudah berhasil mendapatkan hasil
      } finally {
        _isLoading.value = false; // menandakan aplikasi sudah selesai memuat berita 
      }     
}
Future<void> refreshNews() async {
  await fetchTopHeadlines();
  // ini buat refresh berita sesuai kategori yang sedang dipilih
}

// ketika user mau ngubah kategory berita
void selecteCategory(String category) {
  if (_selectedCategory.value != category) {
    _selectedCategory.value = category;
    fetchTopHeadlines(category: category);
    // ini buat ngefetch berita sesuai kategori yang di pilih
  }
}

// pencarian
Future<void> searchNews(String query) async {
  if (query.isEmpty) return;
    // kalo query kosong maka ga usah di proses

    try {
      _isLoading.value = true;
      // menandakan aplikasi sedang memuat berita
      _error.value = ''; // mengosongkan pesan error sebelum melakukan request baru

      final response = await _newsServices.searchNews(query: query);
      // memanggil method searchNews dari news services
      // ini buat nyimpen berita yang di dapat dari server
      _articles.value = response.articles;
      // menyimpan daftar berita yang didapatkan dari server
      // kalo pencarian nya sukses maka akan di tampilkan response articles nya
    } catch (e) {
      _error.value = e.toString();
      // menyimpan pesan error jika terjadi kesalahan saat mengambil data
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      ); 
    }  finally {
      _isLoading.value = false;
      // menandakan aplikasi sudah selesai memuat berita
      
    }
}
}