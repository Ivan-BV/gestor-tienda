import 'package:flutter/material.dart';
import 'package:gestortienda/src/cfg/colors.dart';
import 'package:gestortienda/src/pages/inventory.dart';
import 'package:gestortienda/src/pages/mycart.dart';
import 'package:gestortienda/src/pages/products.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ShopColors.primary,
      ),
      body: _selectedIndex == 0
          ? Products()
          : _selectedIndex == 1
              ? Inventory()
              : Cart(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'Comprar'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Stock"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Carrito"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ShopColors.primary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
