import 'package:flutter/material.dart';
import 'package:tribun_app/utils/app_colors.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer> 
    with SingleTickerProviderStateMixin{
      // SingleTickerProviderStateMixin untuk class mixin untuk mengelola animasi controller buat menyinkronkan refresh rate layar
      // refresh rate layar itu kek patah2 gitu, semakin banyak refresh rate nya semakin halus
      late AnimationController _animationController;
      // late itu buat inisialisasi variabel yang di deklarasi nanti
      late Animation<double> _animation;
      // Animation<double> itu buat animasi yang nilainya double (angka desimal)

      @override
      void initState() {
        super.initState();
        // inisialisasi animasi controller buat mengatur durasi dan sinkronisasi animasi
        _animationController = AnimationController(
         duration: Duration(milliseconds: 1500),
          vsync: this,
        )..repeat();
        // repeat itu buat mengulang animasi terus menerus
        _animation = Tween<double>(
          // Tween itu buat mengatur nilai awal dan akhir animasi
          begin: -1.0, 
          end: 2.0
        ).animate(
          CurvedAnimation(
            // CurvedAnimation itu buat mengatur kurva animasi. kurva animasi itu buat mengatur kecepatan animasi
            parent: _animationController,
            curve: Curves.easeInOut,
        ));
      }
      // ini kode buat inisialisasi animasi controller dan animasi nya

      @override
      void dispose() {
        _animationController.dispose();
        super.dispose();
      }
      // dispose itu buat membersihkan animasi controller ketika widget 
      //di hapus dari widget tree jadi maksudnya gak ada memory leak. leak itu kebocoran memory
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 5,
      // banyaknya item yang di tampilkan
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          // jarak antar card
          elevation: 2,
          // shadow card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // bentuk card nya
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image shimmer
              AnimatedBuilder(
                animation: _animation, 
                builder: (context, child) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      // buat border radius di atas aja
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        // arah gradient nya. maksudnya gradien itu perpindahan warna
                        // itu alignment itu buat ngatur posisi awal dan akhir gradient
                        colors: [
                          AppColors.divider,
                          AppColors.divider.withValues(alpha: 0.5),
                          AppColors.divider,
                        ],
                        // warna gradient nya
                        stops: [
                         0.0,
                         0.5,
                         1.0,
                        ],
                        // ini tuh buat ngatur posisi warna gradient nya
                        transform: GradientRotation(_animation.value * 3.14159),
                      ),
                    ),
                  );
                }
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // source shimmer
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.divider,
                          )
                        );
                      }
                    ),
                    SizedBox(height: 12),

                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title shimmer
                            Container(
                              width: double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.divider,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.divider,
                              ),
                            )
                          ]
                        );
                      }
                    ),
                    SizedBox(height: 12),

                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // subtitle shimmer
                            Container(
                              width: double.infinity,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: AppColors.divider,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: AppColors.divider,
                              ),
                            )
                          ]         
                        );
                      }
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}