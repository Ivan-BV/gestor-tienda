import 'package:flutter/material.dart';
import 'package:gestortienda/src/cfg/cart_provider.dart';
import 'package:gestortienda/src/cfg/shop_database.dart';
import 'package:gestortienda/src/cfg/colors.dart';
import 'package:gestortienda/src/cfg/models.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      return FutureBuilder(
          future: ShopDatabase.instance.getAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                value: null,
              ));
            } else {
              List<CartItem> cartItems = snapshot.data!;
              return cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay productos en la cesta",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          color: ShopColors.backgroundProducts,
                          child: _CartItem(cartItems[index]),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                      itemCount: cartItems.length);
            }
          });
    });
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Row(children: [
        Image.asset(
          cartItem.pathImage,
          width: 100,
        ),
        const Padding(padding: EdgeInsets.only(right: 10, left: 10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cartItem.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "${cartItem.price}€",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "${cartItem.quantity} ${cartItem.quantity == 1 ? "Unidad" : "Unidades"}",
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      cartItem.quantity++;
                      await ShopDatabase.instance.updateCart(cartItem);
                      Provider.of<CartProvider>(context, listen: false)
                          .shouldRefresh();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.green,
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      "+",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      cartItem.quantity--;
                      if (cartItem.quantity == 0) {
                        await ShopDatabase.instance.delete(cartItem.id);
                      } else {
                        await ShopDatabase.instance.updateCart(cartItem);
                      }
                      Provider.of<CartProvider>(context, listen: false)
                          .shouldRefresh();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.red,
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      "-",
                      style: TextStyle(color: Colors.black87),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Total: ${cartItem.totalPrice}€",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ShopColors.buttons),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${cartItem.name} eliminado del carrito"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    await ShopDatabase.instance.delete(cartItem.id);

                    Provider.of<CartProvider>(context, listen: false)
                        .shouldRefresh();
                  },
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(
                      color: ShopColors.fonts,
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ShopColors.buttons),
                  onPressed: () async {
                    Future<List<Product>> Function() products =
                        ShopDatabase.instance.getAllProducts;
                    List<Product> productos = await products();
                    Product? producto;
                    for (var element in productos) {
                      if (element.id == cartItem.id) {
                        producto = element;
                      }
                    }
                    Stock auxStock = Stock(
                        cartItem.id,
                        cartItem.name,
                        producto!.description,
                        cartItem.quantity,
                        cartItem.pathImage);
                    Future<List<Stock>> inventorys =
                        ShopDatabase.instance.getAllStock();
                    List<Stock> inventory = await inventorys;
                    bool isUpdated = false;
                    for (var element in inventory) {
                      if (element.id == auxStock.id) {
                        Stock auxStock2 = element;
                        auxStock.quantity =
                            auxStock.quantity + auxStock2.quantity;
                        await ShopDatabase.instance.updateInventory(auxStock);
                        isUpdated = true;
                      }
                    }
                    if (!isUpdated) {
                      await ShopDatabase.instance.insertStock(auxStock);
                    }
                    await ShopDatabase.instance.delete(cartItem.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${cartItem.name} comprado"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Provider.of<CartProvider>(context, listen: false)
                        .shouldRefresh();
                  },
                  child: const Text(
                    "Comprar",
                    style: TextStyle(color: ShopColors.fonts),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
