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

class DashboardModel {
  final String title;
  final String? icon;
  final Function()? onTap;

  DashboardModel({required this.title, this.icon, this.onTap});
}

class CategoryRepository {
  static List<String> getCategories() {
    return ["Kaos", "Hoodie", "Aksesoris"];
  }
}
