import 'package:flutter/material.dart';
import 'model/model.dart';
import 'product.dart';
import 'cart.dart';
import 'about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Make sure this is the correct file where LoginPage is defined
import 'menu_admin.dart';

class DashboardPage extends StatefulWidget {
  final UserModel user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> _cart = [];

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
                  category: category,
                  onAddToCart: (product) {
                    setState(() {
                      _cart.add(product);
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
                  backgroundColor: Colors.pinkAccent.withOpacity(0.2),
                  child: const Icon(Icons.category,
                      color: Colors.pinkAccent, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  category,
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

  List<Widget> _drawerMenu(BuildContext context) {
    final items = [
      DrawerItem(
        title: "Katalog",
        icon: Icons.store,
        onTap: (context) => Navigator.pop(context),
      ),
      DrawerItem(
        title: "Keranjang",
        icon: Icons.shopping_cart,
        onTap: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartPage(
                cart: _cart,
                onRemove: (index) {
                  setState(() {
                    _cart.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      DrawerItem(
        title: "Tentang Kami",
        icon: Icons.info,
        onTap: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutUs()),
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
                            cart: _cart,
                            onRemove: (index) {
                              setState(() {
                                _cart.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  if (_cart.isNotEmpty)
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
                          _cart.length.toString(),
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
                    widget.user.username,
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
                  accountName: Text(widget.user.username),
                  accountEmail: Text(widget.user.email),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.pinkAccent),
                  ),
                ),
                ..._drawerMenu(context),
                if (widget.user.email == 'admin@admin.com')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text("Menu Admin"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuAdmin(),
                        ),
                      );
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('is_logged_in');
                    await prefs.remove('current_user_email');
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
          body: Column(
            children: [
              Expanded(child: _buildCatalog(context)),
              // Removed Menu Admin button from the body
            ],
          ),
        ),
      ],
    );
  }
}
