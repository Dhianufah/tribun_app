import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles article = Get.arguments as NewsArticles;
  // ini tuh buat nerima data dari screen sebelumnya pake get.arguments

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            // kalo ke skrin dia bakal true
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // flexible spacebar itu buat nyimpen gambarnya
              background: article.urlToImage != null
                  ? CachedNetworkImage(
                    // ? kalo ini true
                    // : kalo ini false
                    // ini tuh yang cached buat ngambil gambar dari internet tapi dia ga bakal pecah jadi makenya cached network image
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.divider,
                      child: Center(
                          child: CircularProgressIndicator(),
                          // circular indicator itu buat roll kalo loading
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.divider,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: AppColors.textHint,
                      ),
                      // yang diatas kode buat image

                    ),
                  )
                  // statement yang akan dijalankan ketika server tidak 
                  //memiliki gambar atau => image == null
                  : Container(
                    // : kalo ini pasti setelahnya false
                    color: AppColors.divider,
                    child: Icon(
                      Icons.newspaper,
                      size: 50,
                      color: AppColors.divider,
                    ),
                  )
            ),
            // ini buat ogo yang bagikan
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareArticle(),
                // kalo onpressed harus pake () => biar jalan kalo manggil share nya langsung ga bakal jalan
              ),
              PopupMenuButton(
                onSelected: (Value) {
                  switch (Value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                      case 'open_browser':
                        _openInBrowser();
                    break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(
                          Icons.copy
                        ),
                        SizedBox(width: 8),
                        Text('Copy Link')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(height: 8),
                        Text('Open in browser'),
                        
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // source end date 
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.source!.name!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                      if (article.publishedAt != null) ...[
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 16),
                  // title
                  if (article.title != null) ...[
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.3
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  // description
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    )
                  ],
                  SizedBox(height:20),
                  if(article.content != null) ...[
                    Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      article.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  // Read full article button
                  if (article.url != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _openInBrowser,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                        ),
                        child: Text(
                          'Read Full Article',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                  SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        // jadi kode share itu udh otomatis buat manggil yang notifikasi bagi linknya (sama buat make linknya doang yang beneran tuh kalo manggil popupmenubutton)
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      // clipboard itu buat ngesave linknya nah trs kenapa pake data buat ngelempar datanya
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2)
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
       
        final Uri url = Uri.parse(article.url!);
         // uri buat parsing biar linknya diketahui oleh orang lain
        // proses menunggu apakah url itu valid dan bisa di buka oleh browser
        if (await canLaunchUrl(url)) {
           // proses menunggu ketika url sudah valid dan sedang di proses oleh browser sampai datanya muncul
          await launchUrl(url, mode: LaunchMode.externalApplication);
          // external itu fungsinya buat kalo misalnya dia mau buka sesuatu tinggal dibuka
        } else {
          Get.snackbar(
            'Error',
            "Couldn't open the link",
            snackPosition: SnackPosition.BOTTOM
          );
        }
    }
  }
}