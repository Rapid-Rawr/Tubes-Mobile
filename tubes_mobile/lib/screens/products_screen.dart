import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api.dart';
import '../models/product.dart';
import '../services/auth.dart';
import '../widgets/product_card.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'transactions_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCartCount();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await ApiService.getProducts();
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList();
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load products: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _loadCartCount() async {
    try {
      final cartItems = await ApiService.getCart();
      setState(() => _cartCount = cartItems.length);
    } catch (e) {
      print('Error loading cart count: $e');
    }
  }

  Future<void> _addToCart(int productId) async {
    final success = await ApiService.addToCart(productId, 1);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          backgroundColor: Colors.green,
        ),
      );
      _loadCartCount();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  ).then((_) => _loadCartCount());
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'transactions') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransactionsScreen(),
                  ),
                );
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'transactions',
                child: Text('My Transactions'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _products.isEmpty
                  ? const Center(child: Text('No products available'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(productId: product.id),
                              ),
                            );
                          },
                          onAddToCart: product.isOutOfStock
                              ? null
                              : () => _addToCart(product.id),
                        );
                      },
                    ),
    );
  }

  Future<void> _logout() async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}