import 'package:flutter/material.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart'; 
import 'home_screen.dart';  

class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> products;

  ProductSearchDelegate({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';  /
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) {
      final productName = product['name'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return productName.contains(searchQuery);  
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.asset(product['image'], width: 40, height: 40),
          title: Text(product['name']),
          subtitle: Text('\$${product['price']}'),
          onTap: () {
            // Aksi saat hasil pencarian dipilih
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Menampilkan saran pencarian
    final suggestions = products.where((product) {
      final productName = product['name'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return productName.contains(searchQuery);  // Menyesuaikan pencarian
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: Image.asset(product['image'], width: 40, height: 40),
          title: Text(product['name']),
          subtitle: Text('\$${product['price']}'),
          onTap: () {
            // Aksi saat saran pencarian dipilih
          },
        );
      },
    );
  }
}
