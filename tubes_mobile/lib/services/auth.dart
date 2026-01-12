import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // UNTUK WEB: gunakan localhost
  static const String baseUrl = 'http://localhost:8000';
  
  // UNTUK CEK KONEKSI
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String telepon,
    required String alamat,
  }) async {
    print('🌐 WEB: Attempting register to: $baseUrl/api/auth/users/');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/users/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          're_password': password,
          'telepon': telepon,
          'alamat': alamat,
        }),
      );

      print('🌐 Response Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final errors = jsonDecode(response.body);
        String errorMessage = 'Registration failed';
        
        if (errors.containsKey('email')) {
          errorMessage = 'Email: ${errors['email'][0]}';
        } else if (errors.containsKey('username')) {
          errorMessage = 'Username: ${errors['username'][0]}';
        }
        
        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      print('🌐 WEB ERROR: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server at $baseUrl\n\n'
                'Please ensure:\n'
                '1. Django server is running: "python manage.py runserver localhost:8000"\n'
                '2. CORS is configured properly\n'
                '3. No other app using port 8000\n\n'
                'Error details: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    print('🌐 WEB: Attempting login to: $baseUrl/api/auth/jwt/create/');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/jwt/create/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('🌐 Login Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(data['access'], data['refresh']);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['detail'] ?? 'Login failed. Check email/password.'
        };
      }
    } catch (e) {
      print('🌐 WEB Login ERROR: $e');
      return {
        'success': false,
        'error': 'Connection error. Please check if Django server is running.'
      };
    }
  }

  static Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}