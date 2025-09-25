import 'package:flutter/material.dart';
import 'detail_produk.dart'; // import halaman detail produk

class ProductPage extends StatelessWidget {
  final String category;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductPage({
    super.key,
    required this.category,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Contoh produk dengan gambar asset (pastikan sudah ada di pubspec.yaml)
    final List<Map<String, dynamic>> products = [
      {
        "name": "$category 1",
        "price": 100000,
        "image": "assets/images/product1.png"
      },
      {
        "name": "$category 2",
        "price": 120000,
        "image": "assets/images/product2.png"
      },
      {
        "name": "$category 3",
        "price": 150000,
        "image": "assets/images/product3.png"
      },
      {
        "name": "$category 4",
        "price": 180000,
        "image": "assets/images/product4.png"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Produk $category"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Image (sama seperti di Dashboard)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/background.png"), // Gambar background
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ListView Produk
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(16), // padding lebih besar
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 90, // gambar lebih besar
                      height: 90,
                      child: product["image"] != null
                          ? Image.asset(
                              product["image"],
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image,
                              size: 60, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    product["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // font lebih besar
                    ),
                  ),
                  subtitle: Text(
                    "Rp ${product["price"]}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16, // font harga juga diperbesar
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.pinkAccent,
                    size: 30, // panah lebih besar
                  ),
                  onTap: () {
                    // Navigasi ke halaman detail produk
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProduk(
                          product: product,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
