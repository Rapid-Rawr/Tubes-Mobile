// import 'package:flutter/material.dart';

// class WishListPage extends StatelessWidget {
//   const WishListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("WishList")
//       )
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart';
import 'package:tubes_mobile/src/history/views/purchase_detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data riwayat pembelian
    final purchases = [
      {'date': '2026-01-10', 'total': 150.00, 'status': 'Selesai', 'products': ['Produk A', 'Produk B']},
      {'date': '2026-01-09', 'total': 200.00, 'status': 'Proses', 'products': ['Produk C']},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("History Pembelian"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            // Pastikan bahwa 'products' adalah List<String> sebelum dipanggil .join
            var productList = purchases[index]['products'];
            String productNames = '';
            if (productList is List<String>) {
              productNames = productList.join(', ');
            }

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(
                  Icons.history,
                  color: Kolors.kPrimary,  
                  size: 40,
                ),
                title: Text(
                  "Tanggal: ${purchases[index]['date']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total: \$${purchases[index]['total']}"),
                    Text("Status: ${purchases[index]['status']}"),
                    Text("Produk: $productNames"), // Menggunakan variable productNames
                  ],
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchaseDetailPage(purchase: purchases[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
