import 'package:get/get.dart';
import 'package:tribun_app/models/news_articles.dart';

class SavedController extends GetxController {
  final RxList<NewsArticles> savedArticles = <NewsArticles>[].obs;

  void toggleSave(NewsArticles article) {
    final isSaved = savedArticles.any((a) => a.url == article.url);
    if (isSaved) {
      savedArticles.removeWhere((a) => a.url == article.url);
    } else {
      savedArticles.add(article);
    }
  }

  bool isArticleSaved(NewsArticles article) {
    return savedArticles.any((a) => a.url == article.url);
  }
}
