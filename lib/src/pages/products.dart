import 'package:flutter/material.dart';
import 'package:gestortienda/src/cfg/shop_database.dart';
import 'package:gestortienda/src/cfg/colors.dart';
import 'package:gestortienda/src/cfg/models.dart';

String tableCartItems = "cart_items";
String tableInventory = "stock";

Future addToCart(Product product) async {
  final item = CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      pathImage: product.pathImage);
  await ShopDatabase.instance.insert(item);
}

Future cargarProductos() async {
  Future<List<Product>> futureProducts = ShopDatabase.instance.getAllProducts();
  List<Product> dbProducts = await futureProducts;
  if (dbProducts.isEmpty) {
    final products = [
      Product(0, "PC Sobremesa", "Ordenador sobremesa premontado", 600,
          "assets/computadora.png"),
      Product(1, "Macbook Pro", "Ordenador Apple Macbook Pro", 1200,
          "assets/macbook-pro.png"),
      Product(2, "iPad", "Tablet Apple iPad", 800, "assets/ipad.png")
    ];
    for (Product product in products) {
      ShopDatabase.instance.insertProduct(product);
    }
  }
}

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    cargarProductos();
    return FutureBuilder(
        future: ShopDatabase.instance.getAllProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              value: null,
            ));
          } else {
            List<Product> products = snapshot.data!;
            return products.isEmpty
                ? const Center(
                    child: Text("No hay productos"),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        color: ShopColors.backgroundProducts,
                        child: _ProductItem(products[index]),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                          height: 1,
                        ),
                    itemCount: products.length);
          }
        });
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(children: [
        Image.asset(
          product.pathImage,
          width: 100,
        ),
        const Padding(padding: EdgeInsets.only(right: 10, left: 10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              product.description,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              "${product.price}€",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: ShopColors.buttons,
                        minimumSize: Size.zero),
                    onPressed: () async {
                      await addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${product.name} agregado al carrito 🛒"),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      "🛒 Añadir al carrito",
                      style: TextStyle(color: ShopColors.fonts),
                    ))
              ],
            )
          ],
        )
      ]),
    );
  }
}
