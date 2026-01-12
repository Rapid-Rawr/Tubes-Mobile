# api/admin.py
from django.contrib import admin
from .models import Barang, Keranjang, Transaksi, DetailTransaksi


@admin.register(Barang)
class BarangAdmin(admin.ModelAdmin):
    list_display = ('nama',  'harga', 'stok', 'created_at')
    search_fields = ('nama', 'deskripsi')

@admin.register(Keranjang)
class KeranjangAdmin(admin.ModelAdmin):
    list_display = ('user', 'barang', 'jumlah', 'subtotal', 'created_at')
    list_filter = ('user',)

@admin.register(Transaksi)
class TransaksiAdmin(admin.ModelAdmin):
    list_display = ('kode_transaksi', 'user', 'total_harga', 'status', 'created_at')
    list_filter = ('status', 'user')
    search_fields = ('kode_transaksi',)

@admin.register(DetailTransaksi)
class DetailTransaksiAdmin(admin.ModelAdmin):
    list_display = ('transaksi', 'barang', 'jumlah', 'harga_satuan', 'subtotal')
    list_filter = ('transaksi',)

