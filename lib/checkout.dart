import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _paymentMethod = 'Transfer Bank';

  // Items passed into checkout (either a single product Map or a List<Map>)
  List<Map<String, dynamic>> _items = [];

  // Shipping options
  final List<Map<String, dynamic>> _shippingOptions = [
    {
      'id': 'jne',
      'name': 'JNE',
      'detail': 'Estimasi 2-4 hari',
      'cost': 15000,
    },
    {
      'id': 'jnt',
      'name': 'JNT',
      'detail': 'Estimasi 1-3 hari',
      'cost': 12000,
    },
    {
      'id': 'shopee',
      'name': 'Shopee Express',
      'detail': 'Estimasi 1-2 hari',
      'cost': 20000,
    },
  ];
  int _selectedShippingIndex = 0;

  final NumberFormat _currency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadUserNameAndEmail();
  }

  Future<void> _loadUserNameAndEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final emailCurrent = prefs.getString('current_user_email');
    final emailRegistered = prefs.getString('user_email');
    final name = prefs.getString('user_name');

    if (emailCurrent != null && emailCurrent.isNotEmpty) {
      _emailController.text = emailCurrent;
    } else if (emailRegistered != null && emailRegistered.isNotEmpty) {
      _emailController.text = emailRegistered;
    }
    if (name != null && name.isNotEmpty) {
      _nameController.text = name;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      if (args is Map<String, dynamic>) {
        // single product passed
        _items = [args];
      } else if (args is List) {
        // cart/list passed
        _items = List<Map<String, dynamic>>.from(args);
      }
    }
    // No selection UI now — we always show all items passed
    setState(() {}); // ensure UI updates if args arrived after build
  }

  int get _subtotal {
    int sum = 0;
    for (var p in _items) {
      final price = (p['price'] is int)
          ? p['price'] as int
          : int.tryParse('${p['price']}') ?? 0;
      sum += price;
    }
    return sum;
  }

  int get _shippingCost =>
      _shippingOptions[_selectedShippingIndex]['cost'] as int;

  int get _grandTotal => _subtotal + _shippingCost;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada produk untuk checkout')));
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Confirmation dialog showing products, subtotal, shipping, grand total
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Penerima: ${_nameController.text}'),
              Text('Email: ${_emailController.text}'),
              const SizedBox(height: 8),
              const Text('Produk:'),
              const SizedBox(height: 6),
              ..._items.map((p) {
                final price = (p['price'] is int)
                    ? p['price'] as int
                    : int.tryParse('${p['price']}') ?? 0;
                return Text('- ${p['name']} (${_currency.format(price)})');
              }),
              const SizedBox(height: 8),
              Text('Subtotal: ${_currency.format(_subtotal)}'),
              Text(
                  'Ongkos kirim (${_shippingOptions[_selectedShippingIndex]['name']}): ${_currency.format(_shippingCost)}'),
              const SizedBox(height: 6),
              Text('Total: ${_currency.format(_grandTotal)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Pembayaran sukses (simulasi)')));
              Navigator.pop(context); // back from checkout
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Checkout'),
            backgroundColor: Colors.pinkAccent,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detail Penerima',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Nama Penerima',
                                  border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Masukkan nama penerima'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                  labelText: 'Email (tidak dapat diubah)',
                                  border: OutlineInputBorder()),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Masukkan email'
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ]),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Products card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Daftar Produk',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            if (_items.isEmpty)
                              const Text('Tidak ada produk untuk checkout'),
                            if (_items.isNotEmpty)
                              ..._items.map((p) {
                                final price = (p['price'] is int)
                                    ? p['price'] as int
                                    : int.tryParse('${p['price']}') ?? 0;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: p['image'] != null
                                      ? Image.asset(p['image'],
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.contain)
                                      : const Icon(Icons.image, size: 40),
                                  title: Text(p['name'] ?? ''),
                                  subtitle: Text(_currency.format(price)),
                                );
                              }),
                            const SizedBox(height: 8),
                            Text('Subtotal: ${_currency.format(_subtotal)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ]),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Shipping card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pengiriman',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...List.generate(_shippingOptions.length, (i) {
                              final opt = _shippingOptions[i];
                              return RadioListTile<int>(
                                value: i,
                                groupValue: _selectedShippingIndex,
                                title: Text(opt['name']),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(opt['detail']),
                                      Text(
                                          'Biaya: ${_currency.format(opt['cost'])}'),
                                    ]),
                                onChanged: (v) => setState(
                                    () => _selectedShippingIndex = v ?? 0),
                              );
                            }),
                            const SizedBox(height: 8),
                            Text(
                                'Ongkos kirim: ${_currency.format(_shippingCost)}'),
                            Text('Total: ${_currency.format(_grandTotal)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ]),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Payment & Pay button
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Metode Pembayaran',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _paymentMethod,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Transfer Bank',
                                    child: Text('Transfer Bank')),
                                DropdownMenuItem(
                                    value: 'OVO', child: Text('OVO')),
                                DropdownMenuItem(
                                    value: 'Dana', child: Text('Dana')),
                                DropdownMenuItem(
                                    value: 'COD', child: Text('COD')),
                              ],
                              onChanged: (v) => setState(
                                  () => _paymentMethod = v ?? 'Transfer Bank'),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent),
                                onPressed: _submit,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.0),
                                  child: Text('Bayar',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
