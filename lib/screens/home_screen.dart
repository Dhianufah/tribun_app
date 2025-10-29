// a brand new way for make a screen using get state management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';

class HomeScreen extends GetView<NewsController>{
  final RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      // 🔥 cuma bagian AppBar ini aja yang diubah
      appBar: AppBar(
        backgroundColor: AppColors.onBackground,
        elevation: 0,
        toolbarHeight: 72,
        title: Row(
          children: [
            const Icon(Icons.grid_view_rounded, color: Colors.white),
            const SizedBox(width: 14),
            Image.asset(
             
              'Assets/images/vector.png',
               alignment: Alignment.center, // pastiin udah ditambah di pubspec.yaml
              height: 70,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () => showSearchDialog(context),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.notifications_none_rounded, color: Colors.white),
          const SizedBox(width: 12),
        ],
      ),

      body: Column(
        children: [
          // categories
          Container(
            height: 45,
            margin: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() => CategoryChip(
                  label: category.capitalize ?? category,
                  isSelected: controller.selectedCategory == category,
                  onTap: () => controller.selecteCategory(category),
                ));
              },
            ),
          ),
          
          // news list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const LoadingShimmer();
              }
              if (controller.error.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return NewsCard(
                      article: article, 
                      onTap: () => Get.toNamed(
                        Routes.NEWS_DETAIL,
                        arguments: article
                      ),
                    );
                  },
                ),
              );
            }) 
          )
        ],
      ),
   );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.newspaper,
            size: 64,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

 void showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search News'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Please type a news..',
            border: OutlineInputBorder()
          ),
          onSubmitted: (value){
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Search'),
          )
        ],
      ),
    );
  }
}
