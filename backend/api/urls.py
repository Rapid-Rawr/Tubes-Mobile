# api/urls.py
from django.urls import path
from . import views

urlpatterns = [
    # Products
    path('products/', views.GetAllProductView.as_view(), name='get-all-products'),
    path('products/<int:id>/', views.GetDetailProductView.as_view(), name='get-detail-product'),
    
    # Cart
    path('cart/', views.KeranjangListView.as_view(), name='cart-list'),
    path('cart/<int:pk>/', views.KeranjangDetailView.as_view(), name='cart-detail'),
    
    # Transactions
    path('transactions/', views.TransaksiListView.as_view(), name='transaction-list'),
    path('transactions/checkout/', views.CreateTransaksiView.as_view(), name='checkout'),
]