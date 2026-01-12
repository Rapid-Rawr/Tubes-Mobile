import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String kodeTransaksi;
  final double totalHarga;
  final String status;
  final String? buktiPembayaranUrl;
  final String alamatPengiriman;
  final List<dynamic> detailTransaksi;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.kodeTransaksi,
    required this.totalHarga,
    required this.status,
    this.buktiPembayaranUrl,
    required this.alamatPengiriman,
    required this.detailTransaksi,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      kodeTransaksi: json['kode_transaksi'],
      totalHarga: double.parse(json['total_harga'].toString()),
      status: json['status'],
      buktiPembayaranUrl: json['bukti_pembayaran_url'],
      alamatPengiriman: json['alamat_pengiriman'],
      detailTransaksi: json['detail_transaksi'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedTotal {
    return 'Rp ${totalHarga.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  String get statusText {
    switch (status) {
      case 'menunggu_pembayaran':
        return 'Menunggu Pembayaran';
      case 'diproses':
        return 'Diproses';
      case 'dikirim':
        return 'Dikirim';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'menunggu_pembayaran':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'dikirim':
        return Colors.purple;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}