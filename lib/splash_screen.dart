import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- TAMBAHKAN INI
import 'login.dart';
import 'DashboardPage.dart'; // <--- Pastikan Anda punya file DashboardPage.dart
import 'model/model.dart'; // <--- Untuk menggunakan UserModel

class SplashScreen extends StatefulWidget {
// ... (Kode lainnya)
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ... (Variabel dan Controller Animasi)
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // ... (Controller dan Animation)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // GANTI TIMER LAMA DENGAN FUNGSI BARU UNTUK CEK LOGIN
    _checkLoginStatus();
  }

  // FUNGSI BARU: Cek status login
  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data email dan nama yang disimpan saat registrasi
    final String? email = prefs.getString('user_email');
    final String? username = prefs.getString('user_name');

    // Tunda selama 4 detik (agar Splash Screen tetap tampil)
    await Future.delayed(const Duration(seconds: 4));

    if (email != null && username != null && mounted) {
      // Jika data ada (sudah login/register), arahkan ke Dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            user: UserModel(username: username, email: email),
          ),
        ),
      );
    } else if (mounted) {
      // Jika data tidak ada (belum login), arahkan ke LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ... (Metode build tetap sama)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi naik-turun
            SlideTransition(
              position: _offsetAnimation,
              child: Image.asset(
                'assets/images/splash.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 40),

            // Loading bar horizontal
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.black12,
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 20),

            // Tambahan tulisan
            const Text(
              "dibuat oleh: Sultan Raffi Suryanegara",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
