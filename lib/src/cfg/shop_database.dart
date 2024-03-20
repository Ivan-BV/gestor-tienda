import 'dart:async';

import 'package:gestortienda/src/cfg/models.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class ShopDatabase {
  static final ShopDatabase instance = ShopDatabase._init();

  static Database? _database;

  ShopDatabase._init();

  final String tableCartItems = "cart_items";
  final String tableInventory = "stock";
  final String tableProducts = "products";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableProducts(
      id INTEGER PRIMARY KEY,
      name TEXT UNIQUE,
      description INTEGER,
      price INTEGER,
      pathImage TEXT
    )''');

    await db.execute('''
    CREATE TABLE $tableCartItems(
      id INTEGER PRIMARY KEY,
      name TEXT UNIQUE,
      price INTEGER,
      quantity INTEGER,
      pathImage TEXT
    )''');

    await db.execute('''
    CREATE TABLE $tableInventory(
      id INTEGER PRIMARY KEY,
      name TEXT UNIQUE,
      description TEXT,
      quantity INTEGER,
      pathImage TEXT
    )''');
  }

  Future insert(CartItem item) async {
    final db = await instance.database;
    await db.insert(tableCartItems, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(tableProducts, product.toMap());
  }

  Future insertStock(Stock stock) async {
    final db = await instance.database;
    await db.insert(tableInventory, stock.toMap());
  }

  Future<List<CartItem>> getAll() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableCartItems);
    return List.generate(maps.length, (i) {
      return CartItem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          quantity: maps[i]['quantity'],
          pathImage: maps[i]['pathImage']);
    });
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProducts);
    return List.generate(maps.length, (i) {
      return Product(maps[i]['id'], maps[i]['name'], maps[i]['description'],
          maps[i]['price'], maps[i]['pathImage']);
    });
  }

  Future<List<Stock>> getAllStock() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableInventory);
    return List.generate(maps.length, (i) {
      return Stock(maps[i]['id'], maps[i]['name'], maps[i]['description'],
          maps[i]['quantity'], maps[i]['pathImage']);
    });
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableCartItems, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteInventory(int id) async {
    final db = await instance.database;
    return await db.delete(tableInventory, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateCart(CartItem item) async {
    final db = await instance.database;
    return await db.update(tableCartItems, item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> updateInventory(Stock item) async {
    final db = await instance.database;
    return await db.update(tableInventory, item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }
}
