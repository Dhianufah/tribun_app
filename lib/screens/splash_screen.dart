import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,

      ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _scaleAnimation= Tween<double>(
        begin: 0.5, 
        end: 1.0
        ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _animationController.forward();

      // navigasi ke halaman utama setelah animasi selesai (3 second)
      Future.delayed(
        Duration(seconds: 3), () {
          // TODO: Defining all route for each screen
          // Get.offAllNamed(Route.HOME);
        }
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10)
                        )]
                      ),
                      child: Icon(
                        Icons.newspaper,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'News App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Stay Updtaed with Lates News',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8)
                      ),
                    ),
                    SizedBox(height: 50),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

