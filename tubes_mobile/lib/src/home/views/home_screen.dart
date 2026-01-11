import 'package:flutter/material.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_search_delegate.dart'; 
import 'package:tubes_mobile/src/cart/views/cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> cartItems = [];

  final List<Map<String, dynamic>> products = [
    {'name': 'Dress Glam', 'price': 150.00, 'image': 'assets/images/dress_glam.png'},
    {'name': 'Jacket Stylish', 'price': 200.00, 'image': 'assets/images/jacket_stylish.png'},
    {'name': 'High Heels', 'price': 120.00, 'image': 'assets/images/high_heels.png'},
    {'name': 'T-Shirt Casual', 'price': 50.00, 'image': 'assets/images/tshirt_casual.png'},
  ];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;  // Set filtered list to show all products initially
  }

  void _filterProducts(String query) {
    final results = products.where((product) {
      final productName = product['name'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return productName.contains(searchQuery);  // Menyesuaikan pencarian
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  // Menambahkan produk ke keranjang
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
    // Mengarahkan ke halaman CartScreen dengan daftar produk yang telah ditambahkan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems), // Mengirimkan cartItems yang sudah terupdate
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fashion Store',
          style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Kolors.kPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products: products),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner promo fashion
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner_promo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            // Kategori Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Kategori Fashion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // Horizontal list kategori
            Container(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard(
                    title: 'Pakaian Wanita',
                    onTap: () {
                      print('Kategori Pakaian Wanita diklik');
                    },
                  ),
                  CategoryCard(
                    title: 'Pakaian Pria',
                    onTap: () {
                      print('Kategori Pakaian Pria diklik');
                    },
                  ),
                  CategoryCard(
                    title: 'Sepatu',
                    onTap: () {
                      print('Kategori Sepatu diklik');
                    },
                  ),
                  CategoryCard(
                    title: 'Aksesoris',
                    onTap: () {
                      print('Kategori Aksesoris diklik');
                    },
                  ),
                ],
              ),
            ),
            
            // Produk Fashion Terbaru
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Produk Fashion Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            
            // GridView produk fashion
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  name: filteredProducts[index]['name'],
                  price: filteredProducts[index]['price'],
                  image: filteredProducts[index]['image'],
                  onAddToCart: () => _addToCart(filteredProducts[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Kartu kategori fashion
class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(title),
          backgroundColor: Kolors.kPrimary,
          labelStyle: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

// Kartu produk fashion
class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final VoidCallback onAddToCart;  // Fungsi untuk menambahkan produk ke keranjang

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('\$${price.toString()}', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: onAddToCart,  // Menambahkan produk ke keranjang
          ),
        ],
      ),
    );
  }
}
