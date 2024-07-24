import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wacmachinetest/model/banner_model.dart';
import 'package:wacmachinetest/model/banner_single.dart';
import 'package:wacmachinetest/model/category_model.dart';
import 'package:wacmachinetest/model/product_model.dart'; // Import your models

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE banners (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          image_path TEXT
        )
      ''');
        db.execute('''
        CREATE TABLE single_banners (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          image_path TEXT
        )
      ''');
        db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sku TEXT,
          product_name TEXT,
          product_image TEXT,
          product_rating INTEGER,
          actual_price TEXT,
          offer_price TEXT,
          discount TEXT,
          product_type TEXT
        )
      ''');
        db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          image_path TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
          ALTER TABLE products
          ADD COLUMN product_type TEXT
        ''');
        }
      },
    );
  }

  Future<void> insertBanner(BannerModel banner, String imagePath) async {
    final db = await database;
    await db.insert(
      'banners',
      {
        'title': banner.title,
        'image_path': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSingleBanner(
      SingleBannerModel singleBanner, String imagePath) async {
    log('Image Path Single: $imagePath');
    final db = await database;
    await db.insert(
      'single_banners',
      {
        'title': singleBanner.title,
        'image_path': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProduct(
      ProductModel product, String productType, String imagePath) async {
    final db = await database;
    await db.insert(
      'products',
      {
        ...product.toJson(),
        'product_type': productType,
        'product_image': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertCategory(CategoryModel category, String imagePath) async {
    final db = await database;
    await db.insert(
      'categories',
      {
        'title': category.title,
        'image_path': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BannerModel>> getBanners() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('banners');
    return List.generate(maps.length, (i) {
      return BannerModel.fromJson(maps[i]);
    });
  }

  Future<List<SingleBannerModel>> getSingleBanners() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('single_banners');
    return List.generate(maps.length, (i) {
      return SingleBannerModel.fromJson(maps[i]);
    });
  }

  Future<List<ProductModel>> getProducts(String productType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'product_type = ?',
      whereArgs: [productType],
    );
    return List.generate(maps.length, (i) {
      return ProductModel.fromJson(maps[i]);
    });
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('banners');
    await db.delete('single_banners');
    await db.delete('products');
  }
}
