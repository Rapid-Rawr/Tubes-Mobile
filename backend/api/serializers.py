# api/serializers.py
from rest_framework import serializers
from .models import  Barang, Keranjang, Transaksi, DetailTransaksi


class BarangSerializer(serializers.ModelSerializer):
    gambar_url = serializers.SerializerMethodField()
    
    class Meta:
        model = Barang
        fields = ['id', 'nama', 'deskripsi', 'harga', 'stok', 
                 'gambar', 'gambar_url', 'created_at']
        read_only_fields = ['created_at']
    
    def get_gambar_url(self, obj):
        if obj.gambar:
            return self.context['request'].build_absolute_uri(obj.gambar.url)
        return None

class SimpleBarangSerializer(serializers.ModelSerializer):
    """Untuk nested relationships"""
    class Meta:
        model = Barang
        fields = ['id', 'nama', 'harga']

class KeranjangSerializer(serializers.ModelSerializer):
    barang_detail = SimpleBarangSerializer(source='barang', read_only=True)
    subtotal = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)
    
    class Meta:
        model = Keranjang
        fields = ['id', 'barang', 'barang_detail', 'jumlah', 'subtotal', 'created_at']
        read_only_fields = ['user', 'created_at']

class DetailTransaksiSerializer(serializers.ModelSerializer):
    barang_detail = SimpleBarangSerializer(source='barang', read_only=True)
    
    class Meta:
        model = DetailTransaksi
        fields = ['id', 'barang', 'barang_detail', 'jumlah', 'harga_satuan', 'subtotal']

class TransaksiSerializer(serializers.ModelSerializer):
    detail_transaksi = DetailTransaksiSerializer(many=True, read_only=True)
    user_email = serializers.EmailField(source='user.email', read_only=True)
    bukti_pembayaran_url = serializers.SerializerMethodField()
    
    class Meta:
        model = Transaksi
        fields = ['id', 'kode_transaksi', 'user', 'user_email', 'total_harga',
                 'status', 'bukti_pembayaran', 'bukti_pembayaran_url',
                 'alamat_pengiriman', 'catatan', 'detail_transaksi',
                 'created_at', 'updated_at']
        read_only_fields = ['user', 'kode_transaksi', 'created_at', 'updated_at']
    
    def get_bukti_pembayaran_url(self, obj):
        if obj.bukti_pembayaran:
            return self.context['request'].build_absolute_uri(obj.bukti_pembayaran.url)
        return None

class CreateTransaksiSerializer(serializers.Serializer):
    """Serializer khusus untuk create transaksi dari keranjang"""
    alamat_pengiriman = serializers.CharField()
    catatan = serializers.CharField(required=False, allow_blank=True)