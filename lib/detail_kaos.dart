import 'package:flutter/material.dart';

class DetailKaos extends StatelessWidget {
  final Map<String, dynamic> product;
  const DetailKaos({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Detail Kaos'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (product['image'] != null)
              Image.asset(product['image'], height: 200),
            const SizedBox(height: 16),
            Text(product['name'] ?? '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Rp ${product['price']}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text('Detail khusus produk Kaos.'),
          ],
        ),
      ),
    );
  }
}
