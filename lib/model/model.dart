import 'package:flutter/material.dart';

/// ----------------------
/// MODEL CATEGORY
/// ----------------------
class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Repository kategori
class CategoryRepository {
  static List<Category> getCategories() {
    return [
      Category(
        name: "Hoodie",
        icon: Icons.checkroom, // ikon pakaian
        color: Colors.blue,
      ),
      Category(
        name: "Kaos",
        icon: Icons.accessibility, // ikon alternatif untuk kaos
        color: Colors.green,
      ),
    ];
  }
}

/// ----------------------
/// MODEL CART
/// ----------------------
class CartModel {
  final List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Map<String, dynamic> product) {
    _cart.add(product);
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
    }
  }

  int get itemCount => _cart.length;
}

/// ----------------------
/// MODEL USER
/// ----------------------
class UserModel {
  final String username;
  final String email;

  UserModel({
    required this.username,
    required this.email,
  });
}

/// ----------------------
/// MODEL DASHBOARD STATE
/// ----------------------
class DashboardModel extends ChangeNotifier {
  final CartModel cartModel = CartModel();

  // Dark mode sudah dihapus
}

/// ----------------------
/// DRAWER ITEM MODEL
/// ----------------------
class DrawerItem {
  final String title;
  final IconData icon;
  final Function(BuildContext context) onTap;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
