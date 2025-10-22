import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart'; // Import GetWidget
import 'package:flutter_application_1/register_page.dart';
import 'DashboardPage.dart'; // Pastikan path ini benar
import 'model/model.dart'; // Pastikan path ini benar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Fungsi untuk mendapatkan widget tombol login dengan GFButton
  Widget getLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: GFButton(
        // Menggunakan GFButton dari GetWidget
        onPressed: _login,
        text: "MASUK",
        shape: GFButtonShape.standard, // Bentuk tombol standar
        color: GFColors.PRIMARY, // Warna biru default GetWidget
        size: GFSize.LARGE, // Ukuran tombol yang lebih besar
        fullWidthButton: true, // Membuat tombol full width
        icon: const Icon(
          Icons.login,
          color: Colors.white,
        ),
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // Logic login berhasil (untuk demo ini, langsung navigasi)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            user: UserModel(
              // Asumsi nama pengguna (username) untuk demo
              username: "Tann",
              email: email,
            ),
          ),
        ),
      );
    } else {
      // Tampilkan SnackBar jika ada field kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password wajib diisi")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/background.png",
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: const Color(0xFFF8BBD0), // Pink pastel
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Selamat Datang!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE573B4), // Pink lucu
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Silakan masuk untuk melanjutkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getLoginButton(),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterPage()),
                          );
                        },
                        child: const Text("Belum punya akun? Daftar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
