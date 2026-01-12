import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<dynamic>> getProducts() async {
  try {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/'),
      headers: headers,
    );

    print('📦 Products Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Handle pagination format
      if (data is Map && data.containsKey('results')) {
        print('📦 Products (pagination): ${data['results'].length} items');
        return data['results'];
      }
      // Jika langsung array
      else if (data is List) {
        print('📦 Products (direct): ${data.length} items');
        return data;
      }
    }
    return [];
  } catch (e) {
    print('Error getting products: $e');
    return [];
  }
}

static Future<List<dynamic>> getTransactions() async {
  try {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/transactions/'),
      headers: headers,
    );

    print('💳 Transactions Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Handle pagination format
      if (data is Map && data.containsKey('results')) {
        print('💳 Transactions (pagination): ${data['results'].length} items');
        return data['results'];
      }
      // Jika langsung array
      else if (data is List) {
        print('💳 Transactions (direct): ${data.length} items');
        return data;
      }
    }
    return [];
  } catch (e) {
    print('Error getting transactions: $e');
    return [];
  }
}

  static Future<Map<String, dynamic>?> getProductDetail(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/$id/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting product detail: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/cart/'),
        headers: headers,
      );

      print('🛒 Cart Response Status: ${response.statusCode}');
      print('🛒 Cart Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle pagination format
        if (data is Map && data.containsKey('results')) {
          print(
              '🛒 Pagination format detected, results count: ${data['results'].length}');
          return data['results']; // Return the array inside 'results'
        }
        // Jika langsung array (format lama)
        else if (data is List) {
          print('🛒 Direct array format detected, count: ${data.length}');
          return data;
        }
      }
      return [];
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  static Future<bool> addToCart(int productId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/'),
        headers: headers,
        body: jsonEncode({'barang': productId, 'jumlah': quantity}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  static Future<bool> updateCartItem(int cartId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/cart/$cartId/'),
        headers: headers,
        body: jsonEncode({'jumlah': quantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating cart: $e');
      return false;
    }
  }

  static Future<bool> removeFromCart(int cartId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/cart/$cartId/'),
        headers: headers,
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> checkout({
    required String alamatPengiriman,
    String catatan = '',
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/transactions/checkout/'),
        headers: headers,
        body: jsonEncode({
          'alamat_pengiriman': alamatPengiriman,
          'catatan': catatan,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }


}
