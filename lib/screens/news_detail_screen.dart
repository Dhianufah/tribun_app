import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/controllers/saved_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final SavedController savedController = Get.find<SavedController>();

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsArticles? article = Get.arguments as NewsArticles?;

    if (article == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                'No article data found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text('Make sure to pass the data when navigating to this page.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: SafeArea(
        child: Stack(
          children: [
            // background nyaa ini
            Hero(
              tag: article.urlToImage ?? article.title ?? '',
              child: CachedNetworkImage(
                imageUrl:
                    article.urlToImage ?? 'https://via.placeholder.com/400x300',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // buat gradient
            Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF1E1E1E)],
                  stops: [0.6, 1.0],
                ),
              ),
            ),

            // main context nya
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _circleButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => Get.back(),
                        ),
                        Row(
                          children: [
                            _circleButton(
                              icon: Icons.share_rounded,
                              onTap: () => _shareArticle(article),
                            ),
                          SizedBox(width: 10),
                            _menuButton(article),
                          ],
                        ),
                      ],
                    ),
                  ),

                 SizedBox(height: 240),
                //  ini yang bagian card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Source Tag
                        if (article.source?.name != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              article.source!.name!,
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),

                      SizedBox(height: 16),
                        // Title
                        Text(
                          article.title ?? 'No title available',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),

                      SizedBox(height: 12),
                        // Author sama tanggal
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),

                         SizedBox(width: 6),
                            Text(
                              article.publishedAt != null
                                  ? timeago.format(article.publishedAt!)
                                  // timeago buat Hitung selisih dari waktu sekarang ke waktu artikel ini diterbitin, terus tulis hasilnya kayak
                                  : 'Unknown date',
                              //Kalau ada tanggal terbit, tunjukin ‘berapa lama lalu’. Tapi kalau gak ada tanggal, tulis aja ‘tanggal gak ada’.
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 22),
                        // Deskripsi
                        if (article.description != null)
                          Text(
                            article.description!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),

                      SizedBox(height: 18),
                        // Content
                        if (article.content != null)
                          Text(
                            article.content!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.7,
                            ),
                          ),

                      SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _iconStat(Icons.remove_red_eye_rounded, "188k"),
                            _iconStat(Icons.favorite_rounded, "40.6k"),
                            _iconStat(Icons.comment_rounded, "10.2k"),
                          ],
                        ),

                      SizedBox(height: 32),
                      // ini buat buttonnya
                        if (article.url != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _openInBrowser(article),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Read more',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black.withOpacity(0.45),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _menuButton(NewsArticles article) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black.withOpacity(0.45),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 20,
        ),
        color: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) async {
          if (value == 'salin') {
            if (article.url != null) {
              await Clipboard.setData(ClipboardData(text: article.url!));
              Get.snackbar(
                'Copied',
                'Link has been copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } else if (value == 'tersimpan') {
            final controller = Get.find<SavedController>();
            controller.toggleSave(article);
            Get.snackbar(
              controller.isArticleSaved(article) ? 'Saved' : 'Removed',
              controller.isArticleSaved(article)
                  ? 'News added to bookmarks'
                  : 'Removed from bookmarks',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        itemBuilder: (context) => [
           PopupMenuItem(
            value: 'salin',
            child: Row(
              children: [
                Icon(Icons.copy, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text('Copy', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        
        PopupMenuItem(
            value: 'tersimpan',
            child: Row(
              children: [
                Icon(Icons.bookmark, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text('Saved', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent, size: 20),

        Text(text, style: TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  void _shareArticle(NewsArticles article) {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check this out!'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  // ini buat pesan errornyaa
  void _openInBrowser(NewsArticles article) async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          "Failed to open the link",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
