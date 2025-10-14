import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tribun_app/models/news_response.dart';
import 'package:tribun_app/utils/constants.dart';
// mendefinisikan sebuah packge atau library menjadi sebuah variable secara langsung
import 'package:http/http.dart' as http;

class NewsServices {
  static const String _baseUrl = Constants.baseUrl;
  static final String _apiKey = Constants.apikey;

// fungsi yang bertujuan untuk mebuat request GET ke server
  Future<NewsResponse> getTopHeadLines({
    String country = Constants.defaultCountry,
    String? Category,
    int page = 1,
    int pageSize = 20,
  }) async {
    // ini buat di halaman pertama saja
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'country': country,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        };

        // statement yang akan dijalankan ketika category tidak null dan tidak kosong
      if (Category != null && Category.isNotEmpty) {
        queryParams['category'] = Category;
      };

      // berfungsi untuk parsing data dari json ke UI
      // simplenya: kita daftarin base url + endpoint yang akan digunakan (URI ->Uniform Resource Identifier) Ngebentuk alamat lengkap server
      // parsing data adalah melempar dan mengambil data dari server

      // jadi ini tuh kodenya uri dalemnya ada base url + endpoint trs replace itu 
      final uri = Uri.parse('$_baseUrl${Constants.topHeadlines}')
          .replace(queryParameters: queryParams); // nanti bakal dari replace itu buat ganti query parameternya yang nantinya bakal ke server
          // mengambil data dari json ke UI
          // fungsi dari kodingan ini adalah untuk mengubah data yang diambil dari server
          // servisis jembatan antar UI ke server
      
      // untuk menyimpan respon yang di berikan oleh server
      final response = await http.get(uri);

      // kode yang akan di jalankan jika request berhasil ke API sukses
      if (response.statusCode == 200) {
        // kalau responnya 200 itu artinya berhasil
        // dari response.body itu bentuknya json, nah ini tuh fungsinya buat ngubah dari json ke bahasa dart 
       final jsonData = json.decode(response.body);
       return NewsResponse.fromJson(jsonData);
       
      //  kode yang akan di jalankan jika request gagal ke API/ status http != 200
      } else {
        throw Exception('Failed to load news, please trs again later');
      }
      
      // kode dijalankan ketika terjadi error lain, selain yang sudah di buat di atas
    } catch (e) {
      throw Exception('Another problem occurred, please try again later');
    }
  }
  // kurung kurawa biar jadi private

  Future<NewsResponse> searchNews({
    required String query, // ini adalah nilai yang dimasukkan ke kolom pencarian
    int page = 1, //ini untuk mendefinisikan halaman berita ke berapa
    int pageSize = 20, // ini untuk mendefinisikan jumlah berita yang di tampilkan per halaman (ketika rendering/ngeloding data dari sourche(databes))
    String? sortBy, // ini untuk mendefinisikan urutan berita berdasarkan apa
  })async{
    try {
      // kalo yang ini buat search berita
      final Map<String, String> queryParams = {
        // ini parameternya
        'apiKey': _apiKey,
        'q': query,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      final uri = Uri.parse('$_baseUrl${Constants.everything}')
          .replace(queryParameters: queryParams);
          // query parameter itu buat ngirim data ke server
      final response = await http.get(uri);
      // data endpoint itu adalah alamat lengkap dari server yang di tuju jadi kalo ada endpoint yang berbeda maka alamat servernya juga berbeda

      if (response.statusCode == 200) {
        // ini buat ngecek kalo responnya 200 itu artinya berhasil
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);

      } else {
        throw Exception('Failed to load news, please try again later');
        
      }
    } catch (e) {
      throw Exception('Another problem occurs, please try again later');
      
    }
  }
}

// jembatan antara server dan klayen -fungsi dari news services