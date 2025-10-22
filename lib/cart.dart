import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(int) onRemove;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image (sama dengan dashboard)
        Image.asset(
          "assets/images/background.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Keranjang"),
            backgroundColor: Colors.pinkAccent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: cart.isEmpty
              ? const Center(
                  child: Text(
                    "Keranjang masih kosong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // biar kontras dengan background
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final product = cart[index];
                    return Dismissible(
                      key: ValueKey(product["name"] + index.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Inform parent to remove the item
                        onRemove(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product["name"]} dihapus')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart,
                              color: Colors.pinkAccent),
                          title: Text(product["name"]),
                          subtitle: Text("Rp ${product["price"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.payment,
                                    color: Colors.green),
                                tooltip: 'Checkout',
                                onPressed: () {
                                  // Navigate to checkout page; expecting the app to implement /checkout route or CheckoutPage
                                  Navigator.pushNamed(context, '/checkout',
                                      arguments: product);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => onRemove(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
