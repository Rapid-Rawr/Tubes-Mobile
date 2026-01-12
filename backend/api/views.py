# Create your views here.
# api/views.py
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from django.db import transaction
import uuid
from datetime import datetime

from .models import Barang, Keranjang, Transaksi, DetailTransaksi
from .serializers import (BarangSerializer, KeranjangSerializer, 
                         TransaksiSerializer, CreateTransaksiSerializer)

# ================ BARANG ================
class GetAllProductView(generics.ListAPIView):
    """Endpoint: GET /api/products/"""
    permission_classes = [permissions.AllowAny]  # Semua bisa lihat produk
    queryset = Barang.objects.filter(stok__gt=0)  # Hanya barang dengan stok > 0
    serializer_class = BarangSerializer
    pagination_class = None  # Nonaktifkan pagination untuk getAllProduct

class GetDetailProductView(generics.RetrieveAPIView):
    """Endpoint: GET /api/products/<id>/"""
    permission_classes = [permissions.AllowAny]
    queryset = Barang.objects.all()
    serializer_class = BarangSerializer
    lookup_field = 'id'

# ================ KERANJANG ================
class KeranjangListView(generics.ListCreateAPIView):
    """Endpoint: GET/POST /api/cart/"""
    permission_classes = [IsAuthenticated]
    serializer_class = KeranjangSerializer
    
    def get_queryset(self):
        return Keranjang.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # Cek stok tersedia
        barang = serializer.validated_data['barang']
        jumlah = serializer.validated_data['jumlah']
        
        if barang.stok < jumlah:
            raise serializers.ValidationError(
                f"Stok tidak cukup. Stok tersedia: {barang.stok}"
            )
        
        # Cek apakah barang sudah ada di keranjang
        keranjang_item, created = Keranjang.objects.get_or_create(
            user=self.request.user,
            barang=barang,
            defaults={'jumlah': jumlah}
        )
        
        if not created:
            # Jika sudah ada, update jumlah
            keranjang_item.jumlah += jumlah
            if keranjang_item.jumlah > barang.stok:
                raise serializers.ValidationError(
                    f"Total jumlah melebihi stok. Stok tersedia: {barang.stok}"
                )
            keranjang_item.save()

class KeranjangDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Endpoint: GET/PUT/DELETE /api/cart/<id>/"""
    permission_classes = [IsAuthenticated]
    serializer_class = KeranjangSerializer
    
    def get_queryset(self):
        return Keranjang.objects.filter(user=self.request.user)

# ================ TRANSAKSI ================
class TransaksiListView(generics.ListAPIView):
    """Endpoint: GET /api/transactions/"""
    permission_classes = [IsAuthenticated]
    serializer_class = TransaksiSerializer
    
    def get_queryset(self):
        return Transaksi.objects.filter(user=self.request.user)

class CreateTransaksiView(APIView):
    """Endpoint: POST /api/transactions/checkout/"""
    permission_classes = [IsAuthenticated]
    
    @transaction.atomic
    def post(self, request):
        serializer = CreateTransaksiSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        user = request.user
        keranjang_items = Keranjang.objects.filter(user=user)
        
        if not keranjang_items.exists():
            return Response(
                {"error": "Keranjang kosong"}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Generate kode transaksi
        kode_transaksi = f"TRX-{datetime.now().strftime('%Y%m%d')}-{uuid.uuid4().hex[:6].upper()}"
        
        # Hitung total harga
        total_harga = sum(item.subtotal for item in keranjang_items)
        
        # Cek stok untuk semua item
        for item in keranjang_items:
            if item.barang.stok < item.jumlah:
                return Response(
                    {"error": f"Stok {item.barang.nama} tidak cukup"},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        # Buat transaksi
        transaksi = Transaksi.objects.create(
            user=user,
            kode_transaksi=kode_transaksi,
            total_harga=total_harga,
            alamat_pengiriman=serializer.validated_data['alamat_pengiriman'],
            catatan=serializer.validated_data.get('catatan', '')
        )
        
        # Buat detail transaksi dan kurangi stok
        for item in keranjang_items:
            DetailTransaksi.objects.create(
                transaksi=transaksi,
                barang=item.barang,
                jumlah=item.jumlah,
                harga_satuan=item.barang.harga
            )
            
            # Kurangi stok
            item.barang.stok -= item.jumlah
            item.barang.save()
        
        # Kosongkan keranjang
        keranjang_items.delete()
        
        # Serialize response
        transaksi_serializer = TransaksiSerializer(
            transaksi, 
            context={'request': request}
        )
        
        return Response(
            {
                "message": "Transaksi berhasil dibuat",
                "transaksi": transaksi_serializer.data
            },
            status=status.HTTP_201_CREATED
        )