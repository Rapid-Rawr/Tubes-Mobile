class CartItem {
  final int id;
  final int barangId;
  final int jumlah;
  final double harga;
  final String nama;
  final Map<String, dynamic>? barangDetail;
  final double subtotal;
  final DateTime? createdAt;

  CartItem({
    required this.id,
    required this.barangId,
    required this.jumlah,
    required this.harga,
    required this.nama,
    this.barangDetail,
    required this.subtotal,
    this.createdAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final barangId = json['barang'] ?? 0;
    final barangDetail = json['barang_detail'] ?? {};
    
    // Parse harga dari string
    double harga = 0.0;
    if (barangDetail['harga'] != null) {
      if (barangDetail['harga'] is String) {
        harga = double.tryParse(barangDetail['harga']) ?? 0.0;
      } else if (barangDetail['harga'] is num) {
        harga = barangDetail['harga'].toDouble();
      }
    }
    
    // Parse subtotal
    double subtotalValue = 0.0;
    if (json['subtotal'] != null) {
      if (json['subtotal'] is String) {
        subtotalValue = double.tryParse(json['subtotal']) ?? 0.0;
      } else if (json['subtotal'] is num) {
        subtotalValue = json['subtotal'].toDouble();
      }
    }
    
    // Parse created_at
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.parse(json['created_at'].toString());
      } catch (e) {
        print('Error parsing created_at: $e');
      }
    }
    
    return CartItem(
      id: json['id'] ?? 0,
      barangId: barangId,
      jumlah: json['jumlah'] ?? 0,
      harga: harga,
      nama: barangDetail['nama']?.toString() ?? 'Unknown Product',
      barangDetail: barangDetail is Map<String, dynamic> ? barangDetail : null,
      subtotal: subtotalValue,
      createdAt: createdAt,
    );
  }

  // Update getter subtotal untuk konsistensi
  double get calculatedSubtotal => harga * jumlah;

  String get formattedSubtotal {
    return 'Rp ${subtotal.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
  
  // Untuk debug
  @override
  String toString() {
    return 'CartItem(id: $id, barangId: $barangId, nama: "$nama", jumlah: $jumlah, harga: $harga, subtotal: $subtotal)';
  }
}