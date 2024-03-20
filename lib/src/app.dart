import 'package:flutter/material.dart';
import 'package:gestortienda/src/cfg/cart_provider.dart';
import 'package:gestortienda/src/pages/home.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Raleway'),
      home: ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const Home(title: "Gestor de tienda"),
      ),
    );
  }
}
