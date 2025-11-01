import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tribun_app/models/news_articles.dart';

class HistoryController extends GetxController {
  // List riwayat baca
  final history = <Map<String, dynamic>>[].obs;

  // Tambah artikel ke riwayat
  void addToHistory(NewsArticles article) {
    // Cegah duplikat
    if (!history.any((item) => item['title'] == article.title)) {
      final formattedTime = _formatTime(article.publishedAt);

      history.insert(0, {
        'title': article.title ?? 'Tanpa Judul',
        'source': article.source?.name ?? 'Tidak diketahui',
        'time': formattedTime,
        'image': article.urlToImage, // simpan gambar juga biar bisa ditampilin
      });
    }
  }

  // Bersihkan semua riwayat
  void clearHistory() {
    history.clear();
  }

  // Format tanggal jadi lebih manusiawi (sudah pakai DateTime)
  String _formatTime(DateTime? publishedAt) {
    if (publishedAt == null) return '-';
    try {
      return DateFormat('dd MMM yyyy, HH:mm').format(publishedAt);
    } catch (e) {
      return '-';
    }
  }
}
