import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  double _total = 0;
  bool _isLoading = true;
  bool _isCheckingOut = false;
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await ApiService.getCart();
      final items = data.map((json) => CartItem.fromJson(json)).toList();
      
      double total = 0;
      for (var item in items) {
        total += item.subtotal;
      }
      
      setState(() {
        _cartItems = items;
        _total = total;
      });
    } catch (e) {
      print('Error loading cart: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _updateQuantity(int cartId, int newQuantity) async {
    if (newQuantity < 1) return;
    
    final success = await ApiService.updateCartItem(cartId, newQuantity);
    if (success) {
      _loadCart();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update quantity'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeItem(int cartId) async {
    final success = await ApiService.removeFromCart(cartId);
    if (success) {
      _loadCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove item'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _checkout() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter shipping address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isCheckingOut = true);

    final result = await ApiService.checkout(
      alamatPengiriman: _addressController.text.trim(),
    );

    setState(() => _isCheckingOut = false);

    if (result != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Order placed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to products
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _cartItems.isEmpty
                      ? const Center(
                          child: Text('Your cart is empty'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: item.barangDetail?['gambar_url'] != null
                                    ? Image.network(
                                        item.barangDetail!['gambar_url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image, size: 40),
                                title: Text(
                                  item.barangDetail?['nama'] ?? 'Product',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price: ${_formatPrice(item.barangDetail?['harga'] ?? 0)}'),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => _updateQuantity(
                                            item.id,
                                            item.jumlah - 1,
                                          ),
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                        ),
                                        Container(
                                          width: 40,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            '${item.jumlah}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => _updateQuantity(
                                            item.id,
                                            item.jumlah + 1,
                                          ),
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                        ),
                                        const Spacer(),
                                        Text(
                                          item.formattedSubtotal,
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeItem(item.id),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_cartItems.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: const Border(top: BorderSide(color: Colors.grey)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatPrice(_total),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Shipping Address',
                            border: OutlineInputBorder(),
                            hintText: 'Enter your complete address',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isCheckingOut ? null : _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: _isCheckingOut
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Checkout',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}