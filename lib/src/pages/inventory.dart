import 'package:flutter/material.dart';
import 'package:gestortienda/src/cfg/cart_provider.dart';
import 'package:gestortienda/src/cfg/shop_database.dart';
import 'package:gestortienda/src/cfg/colors.dart';
import 'package:gestortienda/src/cfg/models.dart';
import 'package:provider/provider.dart';

class Inventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      return FutureBuilder(
          future: ShopDatabase.instance.getAllStock(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                value: null,
              ));
            } else {
              List<Stock> stock = snapshot.data!;
              return stock.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay productos en stock",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          color: ShopColors.backgroundProducts,
                          child: _InventoryItem(stock[index]),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                      itemCount: stock.length);
            }
          });
    });
  }
}

class _InventoryItem extends StatelessWidget {
  final Stock stock;

  const _InventoryItem(this.stock);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(children: [
        Image.asset(
          stock.pathImage,
          width: 100,
        ),
        const Padding(padding: EdgeInsets.only(right: 10, left: 10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stock.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              stock.description,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              "En stock: ${stock.quantity}",
              style: const TextStyle(fontSize: 15),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ShopColors.buttons),
                onPressed: () async {
                  await ShopDatabase.instance.deleteInventory(stock.id);
                  Provider.of<CartProvider>(context, listen: false)
                      .shouldRefresh();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${stock.name} eliminado del stock"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "Eliminar stock",
                  style: TextStyle(color: ShopColors.fonts),
                ))
          ],
        ),
      ]),
    );
  }
}
