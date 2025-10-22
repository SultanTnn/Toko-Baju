import 'package:flutter/material.dart';
import 'model/model.dart';
// ... (Import lainnya)
import 'profile.dart'; // <--- (A) IMPORT PROFILE PAGE
import 'product.dart';
import 'keranjang_page.dart'; // Asumsi Anda punya KeranjangPage

class DashboardPage extends StatefulWidget {
  final UserModel user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; // Index halaman yang sedang aktif (0: Home/Product)

  // (B) BUAT LIST Halaman yang akan ditampilkan di Body
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman, termasuk ProfilePage
    _pages = <Widget>[
      // Halaman 0: Product (Home)
      ProductPage(category: 'Semua', onAddToCart: _addToCart),

      // Halaman 1: Keranjang (asumsi nama file/classnya)
      KeranjangPage(cartModel: DashboardModel().cartModel),

      // Halaman 2: Profile (Menerima data user dari widget.user)
      ProfilePage(user: widget.user), // <--- (C) TAMBAHKAN PROFILE PAGE
    ];
  }

  // ... (Fungsi _addToCart dan lainnya)
  void _addToCart(Map<String, dynamic> product) {
    // ... (logic add to cart)
  }

  // Fungsi untuk mengubah halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard E-Commerce'),
        backgroundColor: Colors.blueAccent,
      ),

      // (D) GANTI BODY DENGAN LIST PAGES
      body: _pages.elementAt(_selectedIndex),

      // (E) IMPLEMENTASI BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ikon Profil
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped, // Panggil fungsi saat item diklik
      ),
    );
  }
}
