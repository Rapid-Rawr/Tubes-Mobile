# api/urls.py
from django.urls import path
from . import views

urlpatterns = [
    # products
    path('products/', views.GetAllProductView.as_view(), name='get-all-products'),
    path('products/<int:id>/', views.GetDetailProductView.as_view(), name='get-detail-product'),
    
    # cart
    path('cart/', views.KeranjangListView.as_view(), name='cart-list'),
    
    # transactions
    path('transactions/', views.TransaksiListView.as_view(), name='transaction-list'),
    path('transactions/checkout/', views.CreateTransaksiView.as_view(), name='checkout'),
]