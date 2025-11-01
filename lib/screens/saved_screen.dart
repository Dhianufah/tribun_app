import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/saved_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/models/news_articles.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SavedController savedController = Get.find<SavedController>();

    return Scaffold(
      backgroundColor: AppColors.onBackground,
      appBar: AppBar(
        backgroundColor: AppColors.onBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.offNamed(Routes.HOME),
        ),
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (savedController.savedArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, color: Colors.grey, size: 70),
                SizedBox(height: 12),
                Text(
                  'No saved articles yet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  'Save your favorite news to read later.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: savedController.savedArticles.length,
          itemBuilder: (context, index) {
            final NewsArticles article = savedController.savedArticles[index];

            return GestureDetector(
              onTap: () => Get.toNamed('/news-detail', arguments: article),
              child: Container(
                margin: EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color:Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article Image
                    article.urlToImage != null
                        ? Image.network(
                            article.urlToImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[900],
                            child: Icon(
                              Icons.image_not_supported_rounded,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),

                    // Article Info
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title ?? 'Untitled Article',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                article.source?.name ?? 'Unknown source',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.pinkAccent,
                                ),
                                onPressed: () {
                                  savedController.savedArticles.remove(article);
                                  Get.snackbar(
                                    'Removed',
                                    'Article has been deleted from bookmarks',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.black.withOpacity(
                                      0.9,
                                    ),
                                    colorText: Colors.white,
                                    margin: EdgeInsets.all(12),
                                    borderRadius: 12,
                                    duration: Duration(seconds: 2),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: AppColors.onBackground,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Get.offNamed(Routes.HOME);
          if (index == 2) Get.offNamed(Routes.ACCOUNT);
        },
        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
