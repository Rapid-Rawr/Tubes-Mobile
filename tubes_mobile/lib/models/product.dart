class Product {
  final int id;
  final String nama;
  final String deskripsi;
  final double harga;
  final int stok;
  final String? gambarUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    this.gambarUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: double.parse(json['harga'].toString()),
      stok: json['stok'],
      gambarUrl: json['gambar_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedPrice {
    return 'Rp ${harga.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  bool get isOutOfStock => stok <= 0;
}