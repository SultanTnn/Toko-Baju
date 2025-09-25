import 'package:flutter/material.dart';
import 'login.dart';
import 'product.dart';
import 'cart.dart';
import 'model/model.dart'; // semua model OOP ada di sini

class DashboardPage extends StatefulWidget {
  final UserModel user; // ambil user dari model.dart

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardModel _dashboardModel = DashboardModel();

  /// Katalog dipanggil dari CategoryRepository (model.dart)
  Widget _buildCatalog(BuildContext context) {
    final categories = CategoryRepository.getCategories();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductPage(
                  category: category.name,
                  onAddToCart: (product) {
                    setState(() {
                      _dashboardModel.cartModel.addToCart(product);
                    });
                  },
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: category.color.withOpacity(0.2),
                  child: Icon(category.icon, color: category.color, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Drawer items dipanggil dari model.dart
  List<Widget> _drawerMenu(BuildContext context) {
    final items = [
      DrawerItem(
        title: "Katalog",
        icon: Icons.store,
        onTap: (ctx) => Navigator.pop(ctx),
      ),
      DrawerItem(
        title: "Keranjang",
        icon: Icons.shopping_cart,
        onTap: (ctx) {
          Navigator.pop(ctx);
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => CartPage(
                cart: _dashboardModel.cartModel.cart,
                onRemove: (index) {
                  setState(() {
                    _dashboardModel.cartModel.removeFromCart(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    ];

    return items
        .map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () => item.onTap(context),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/background.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Dashboard"),
            backgroundColor: Colors.pinkAccent,
            actions: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartPage(
                            cart: _dashboardModel.cartModel.cart,
                            onRemove: (index) {
                              setState(() {
                                _dashboardModel.cartModel.removeFromCart(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  if (_dashboardModel.cartModel.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _dashboardModel.cartModel.itemCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.pinkAccent),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Tann", // Nama user diubah menjadi Tann
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.pinkAccent),
                  accountName:
                      const Text("Tann"), // Nama user diubah menjadi Tann
                  accountEmail: Text(widget.user.email),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.pinkAccent),
                  ),
                ),
                ..._drawerMenu(context),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          body: _buildCatalog(context),
        ),
      ],
    );
  }
}
