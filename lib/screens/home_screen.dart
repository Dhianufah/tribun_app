import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/controllers/history_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';

class HomeScreen extends GetView<NewsController> {
  final RxInt selectedIndex = 0.obs;
  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool showCategories = false.obs;

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: AppColors.onBackground,
     appBar: PreferredSize(
  preferredSize: Size.fromHeight(80),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.85),
          Colors.blueGrey.shade900.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blueAccent.withOpacity(0.4),
          offset: Offset(0, 6),
          blurRadius: 24,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.cyanAccent.withOpacity(0.15),
          offset: Offset(0, -2),
          blurRadius: 10,
        ),
      ],
      border: Border(
        bottom: BorderSide(
          color: Colors.white.withOpacity(0.15),
          width: 0.8,
        ),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Stack(
      children: [
        // ✨ Animated light sweep effect (nyapu pelan)
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: 0.2,
            duration: Duration(seconds: 2),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [0.1, 0.5, 0.9],
                  begin: Alignment(-1.5, -0.5),
                  end: Alignment(1.5, 0.5),
                  transform: GradientRotation(DateTime.now().millisecond / 1000),
                ),
              ),
            ),
          ),
        ),

        // 🎯 Actual AppBar content
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.grid_view_rounded, color: Colors.white),
                onPressed: () =>
                    showCategories.value = !showCategories.value,
              ),
              SizedBox(width: 14),
              Image.asset(
                'assets/images/vector.png',
                alignment: Alignment.center,
                height: 65,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: isSearching.value
                        ? Container(
                            key: ValueKey('searchBar'),
                            height: 42,
                            margin: EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: searchController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search news...',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  controller.searchNews(value);
                                }
                              },
                            ),
                          )
                        : SizedBox(key: ValueKey('emptySpace')),
                  );
                }),
              ),
            ],
          ),
          actions: [
            Obx(() {
              return IconButton(
                icon: Icon(
                  isSearching.value
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isSearching.value) {
                    isSearching.value = false;
                    searchController.clear();
                    controller.refreshNews();
                  } else {
                    isSearching.value = true;
                  }
                },
              );
            }),
          ],
        ),
      ],
    ),
  ),
),

      // ini body nya
      body: Obx(() {
        return Row(
          children: [
            // Sidebar kategori
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: showCategories.value ? 140 : 0,
              child: AnimatedSlide(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                offset: showCategories.value ? Offset.zero : Offset(-1, 0),
                child: AnimatedOpacity(
                  opacity: showCategories.value ? 1 : 0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: IgnorePointer(
                    ignoring: !showCategories.value,
                    child: Container(
                      color: AppColors.onBackground,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          final isSelected =
                              controller.selectedCategory == category;
                          return GestureDetector(
                            onTap: () {
                              controller.selecteCategory(category);
                              showCategories.value = false;
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white24
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  category.capitalize ?? category,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Daftar berita utama
            Expanded(
              child: Obx(() {
                if (controller.isLoading) return LoadingShimmer();
                if (controller.error.isNotEmpty) return _buildErrorWidget();
                if (controller.articles.isEmpty) return _buildEmptyWidget();

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return NewsCard(
                        article: article,
                        onTap: () {
                          historyController.addToHistory(article);
                          Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        );
      }),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.onBackground,
          currentIndex: selectedIndex.value,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            selectedIndex.value = index;
            switch (index) {
              case 0:
                Get.offAllNamed(Routes.HOME);
                break;
              case 1:
                Get.offAllNamed(Routes.SAVED);
                break;
              case 2:
                Get.offAllNamed(Routes.ACCOUNT);
                break;
            }
          },
           items: [
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
      ),
    );
  }

  // Widget jika kosong
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: AppColors.textHint),
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
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Widget error nya
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),

        SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        SizedBox(height: 24),
          ElevatedButton(
            onPressed: Get.find<NewsController>().refreshNews,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
