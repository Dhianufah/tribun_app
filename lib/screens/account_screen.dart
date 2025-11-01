import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/controllers/history_controller.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final historyC = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF1C1C1E), // dark background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                  CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),

                  SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text(
                            'Dhia Nufah',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 6),
                          Text(
                            'dhianufah30@email.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 32),
              // buat logout button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                icon: Icon(Icons.logout_rounded),
                label: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor:Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Sign Out?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      content: Text(
                        'Are you sure you want to sign out from this account?',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.pinkAccent)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Get.offAllNamed(Routes.SPLASH),
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),

            SizedBox(height: 32),
              // bagian history kalo yang ini mah
              Text(
                'Reading History',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

            SizedBox(height: 16),
              Obx(() {
                if (historyC.history.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Column(
                        children:[
                          Icon(Icons.history, size: 60, color: Colors.grey),
                          SizedBox(height: 14),
                          Text(
                            'No reading history yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: historyC.history.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = historyC.history[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color:Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.article_rounded,
                              color: Colors.pinkAccent,
                            ),
                          ),

                        SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              
                              SizedBox(height: 4),
                                Text(
                                  '${item['source'] ?? ''} • ${item['time'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),

            SizedBox(height: 30),
            // ini buat button apus history
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    if (historyC.history.isNotEmpty) {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor:Color(0xFF2C2C2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'Clear All History?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          content: Text(
                            'Are you sure you want to delete all reading history?',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(color: Colors.pinkAccent),
                              ),
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.pinkAccent)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                              ),
                              onPressed: () {
                                historyC.clearHistory();
                                Get.back();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.delete_forever,
                      color: Colors.pinkAccent),
                  label: Text(
                    'Clear All History',
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: Color(0xFF2C2C2E),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Get.offNamed(Routes.HOME);
          if (index == 1) Get.offNamed(Routes.SAVED);
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
