import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final void Function(BuildContext) onTap;

  DrawerItem({required this.title, required this.icon, required this.onTap});
}

class UserModel {
  final String username;
  final String email;

  UserModel({required this.username, required this.email});
}

class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});
}

class DashboardModel {
  final String title;
  final String? icon;
  final Function()? onTap;

  DashboardModel({this.title = '', this.icon, this.onTap});

  // Dummy cartModel getter
  List<Map<String, dynamic>> get cartModel => [];

  List<Product> get products => [
        Product(
            name: 'Kaos 1', price: 100000, image: 'assets/images/Kaos1.png'),
        Product(
            name: 'Kaos 2', price: 120000, image: 'assets/images/Kaos2.png'),
        Product(
            name: 'Kaos 3', price: 150000, image: 'assets/images/Kaos3.png'),
        Product(
            name: 'Hoodie 1',
            price: 200000,
            image: 'assets/images/Hoodie1.png'),
        Product(
            name: 'Hoodie 2',
            price: 220000,
            image: 'assets/images/Hoodie2.png'),
        Product(
            name: 'Hoodie 3',
            price: 250000,
            image: 'assets/images/Hoodie3.png'),
      ];
}

class CategoryRepository {
  static List<String> getCategories() {
    return ["Kaos", "Hoodie", "Aksesoris"];
  }
}
