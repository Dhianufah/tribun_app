import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/routes/app_pages.dart';

// Class untuk menggambar lingkaran titik-titik (dashed circle)
class DashedCirclePainter extends CustomPainter {
  final double progress; // Digunakan untuk animasi rotation/fade jika perlu

  DashedCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 4;
    double dashSpace = 8;
    double dashCount = 30; // Jumlah total titik

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint paint = Paint()
      ..color = Colors
          .white // Warna titik-titik
      ..strokeWidth = 2.0
      ..style = PaintingStyle
          .fill; // Menggunakan fill agar terlihat seperti titik (dot)

    // Hitung jarak angular antar titik
    final double angleStep = (2 * pi) / dashCount;

    // Gambar titik-titik
    for (int i = 0; i < dashCount; i++) {
      // Hitung sudut rotasi, tambahkan progress untuk animasi putaran
      final double angle = i * angleStep + (progress * 2 * pi);
      final double x = center.dx + radius * cos(angle);
      final double y = center.dy + radius * sin(angle);

      // ini buat gambar lingkaran kecil (titik)
      canvas.drawCircle(Offset(x, y), dashWidth / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint setiap animasi berubah
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Mengubah SingleTickerProviderStateMixin menjadi TickerProviderStateMixin

  late AnimationController _fillController;
  late Animation<double> _fillAnimation;

  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk Animasi Isi Tombol (Fill-Up)
    _fillController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _fillAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fillController, curve: Curves.easeInOut),
    );
    _fillController.forward();

    // 2. Controller untuk Animasi Putaran Lingkaran Titik-titik
    _rotateController = AnimationController(
      duration: Duration(seconds: 8), // Rotasi lebih lambat
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotateController);
    _rotateController.repeat(); // buat muter2

    // Setelah animasi fill-up selesai (4 detik), pindah ke HOME
    Future.delayed(const Duration(seconds: 4), () {
      _rotateController.stop(); // Hentikan putaran saat pindah
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    _fillController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  // Widget untuk tombol JELAJAHI BERITA yang sudah kita buat
  Widget _buildFillUpButton(double progress) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          // Border berubah dari putih ke warna gradien saat diisi
          color:
              Color.lerp(
                Colors.white.withOpacity(0.5),
                Color(0xFF4FACFE),
                progress,
              ) ??
              Colors.white.withOpacity(0.5),
          width: 2,
        ),
        // Kunci utama: Gradasi yang Mengisi dan Tetap Terlihat Gradien
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // 4 stops untuk 2 warna transparan & 2 warna gradien
          stops: [0.0, progress, progress, 1.0],
          colors: [
            Colors.transparent, // Bagian kiri kosong
            Colors.transparent, // Hingga progress
            Color(0xFF4FACFE), // Mulai gradien
            Color(0xFF00F2FE), // Hingga akhir tombol
          ],
        ),
      ),
      child: Text(
        "JELAJAHI BERITA",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran lingkaran akan sedikit lebih besar dari tombol.
    double buttonWidth = 280; // Sesuaikan dengan perkiraan lebar tombol
    double circleSize = 200; // Ukuran diameter lingkaran titik-titik

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background full screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              alignment:
                  Alignment.topCenter, // ini yang bikin gambar “naik ke atas”
            ),
          ),

          // ini buat si lingkaran
          Align(
            alignment: Alignment.bottomCenter, // posisikan di bawah layar
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 120,
              ), // atur jarak dari bawah
              child: SizedBox(
                width: buttonWidth,
                height: circleSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran Titik-titik Berputar
                    AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CustomPaint(
                            painter: DashedCirclePainter(
                              progress: _rotateAnimation.value,
                            ),
                          ),
                        );
                      },
                    ),

                    // Tombol JELAJAHI BERITA
                    AnimatedBuilder(
                      animation: _fillAnimation,
                      builder: (context, child) {
                        return _buildFillUpButton(_fillAnimation.value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
