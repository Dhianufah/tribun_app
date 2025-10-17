import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final NewsArticles article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: AppColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // inkwell itu buat efek klik
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            if (article.urlToImage != null)
            // cek apakah urlToImage null atau tidak kalo null atau kosong ga usah di tampilkan
              ClipRRect(
                // cliprect itu buat munculin image jadi kalo pake ini image nya bakal lebih bagus
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                // nah kode yang di bawah biar semua gambar di artikelnya nanti sama ga ada yang beda
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppColors.divider,
                    child: Center(
                      child: CircularProgressIndicator(
                        // circularprogressindicator itu buat loading kalo gambarnya belum ke load
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  // kalo error misalnya gambarnya ga ke load. munculin icon broken image
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppColors.divider,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textHint,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title, source news and date
                    Row(
                      children: [
                        if (article.source?.name != null)...[
                            // kalo artikenya ada nama sourcenya maka tampilkan
                          Expanded(
                            child: Text(
                              article.source!.name!,
                              // ini buat kalo namanya kepanjangan di batasin 1 baris doang.
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
                          SizedBox(width: 8),
                        ],
                          //  timestamp
                         if (article.publishedAt != null)
                         Text(
                          // ini tuh biar waktu yang tampil itu jadi waktu yang relatif misalnya 5 menit yang lalu, 2 jam yang lalu
                          // sama biar enak di baca jadi kek lasngsung hari gitu (contoh a day ago)
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          // pake parse karena publishedAt itu String jadi di parse dulu ke DateTime biar dia mau di panggil
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                         )
                      ],
                    ),
                    SizedBox(height: 12),
                    // title
                    if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      // maxlines ini fungsinya buat ngebates teksnya kalo kepanjangan jadi cuman 3 baris
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // deskription
                    if (article.description != null)
                    // jika article deskription tidak null/kosong maka tampilkan
                    Text(
                      article.description!,
                      // ini kode yang article itu cara buat ngambil data langsung dari artikelnya
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
          ] 
        )
      )   
    );
  }
}