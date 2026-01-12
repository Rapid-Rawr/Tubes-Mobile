# api/models.py
from django.db import models
from django.conf import settings


class Barang(models.Model):
    nama = models.CharField(max_length=200)
    deskripsi = models.TextField()
    harga = models.DecimalField(max_digits=12, decimal_places=2)
    stok = models.IntegerField(default=0)
    gambar = models.ImageField(upload_to='barang/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.nama
    
    class Meta:
        ordering = ['-created_at']

class Keranjang(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='keranjang')
    barang = models.ForeignKey(Barang, on_delete=models.CASCADE)
    jumlah = models.IntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.email} - {self.barang.nama}"
    
    @property
    def subtotal(self):
        return self.jumlah * self.barang.harga
    
    class Meta:
        unique_together = ['user', 'barang']  # Satu user tidak bisa punya barang yang sama di keranjang
        ordering = ['-created_at']

class Transaksi(models.Model):
    STATUS_CHOICES = [
        ('menunggu_pembayaran', 'Menunggu Pembayaran'),
        ('diproses', 'Diproses'),
        ('dikirim', 'Dikirim'),
        ('selesai', 'Selesai'),
        ('dibatalkan', 'Dibatalkan'),
    ]
    
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='transaksi')
    kode_transaksi = models.CharField(max_length=50, unique=True)
    total_harga = models.DecimalField(max_digits=15, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='menunggu_pembayaran')
    bukti_pembayaran = models.ImageField(upload_to='bukti_pembayaran/', blank=True, null=True)
    alamat_pengiriman = models.TextField()
    catatan = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.kode_transaksi} - {self.user.email}"
    
    class Meta:
        ordering = ['-created_at']

class DetailTransaksi(models.Model):
    transaksi = models.ForeignKey(Transaksi, on_delete=models.CASCADE, related_name='detail_transaksi')
    barang = models.ForeignKey(Barang, on_delete=models.CASCADE)
    jumlah = models.IntegerField()
    harga_satuan = models.DecimalField(max_digits=12, decimal_places=2)
    subtotal = models.DecimalField(max_digits=15, decimal_places=2)
    
    def __str__(self):
        return f"{self.transaksi.kode_transaksi} - {self.barang.nama}"
    
    def save(self, *args, **kwargs):
        # Auto calculate subtotal
        self.subtotal = self.jumlah * self.harga_satuan
        super().save(*args, **kwargs)
    
    class Meta:
        ordering = ['-id']