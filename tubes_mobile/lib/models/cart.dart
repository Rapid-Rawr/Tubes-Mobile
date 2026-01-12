class CartItem {
  final int id;
  final int barang;
  final Map<String, dynamic>? barangDetail;
  final int jumlah;
  final double subtotal;
  final DateTime createdAt;

  CartItem({
    required this.id,
    required this.barang,
    this.barangDetail,
    required this.jumlah,
    required this.subtotal,
    required this.createdAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      barang: json['barang'],
      barangDetail: json['barang_detail'],
      jumlah: json['jumlah'],
      subtotal: double.parse(json['subtotal'].toString()),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedSubtotal {
    return 'Rp ${subtotal.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}