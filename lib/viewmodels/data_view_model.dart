import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wacmachinetest/model/banner_model.dart';
import 'package:wacmachinetest/model/banner_single.dart';
import 'package:wacmachinetest/model/category_model.dart';
import 'package:wacmachinetest/model/product_model.dart';
import 'package:wacmachinetest/services/api_service.dart';
import 'package:wacmachinetest/services/database_helper.dart';
import 'package:wacmachinetest/services/imagesecurity.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<BannerModel> _banners = [];
  List<SingleBannerModel> _singleBanners = [];
  List<ProductModel> _popularproducts = [];
  List<CategoryModel> _categories = [];
  List<ProductModel> _feauturedproducts = [];

  List<BannerModel> get banners => _banners;
  List<SingleBannerModel> get singleBanners => _singleBanners;
  List<ProductModel> get popularproducts => _popularproducts;
  List<ProductModel> get feauturedproducts => _feauturedproducts;
  List<CategoryModel> get categories => _categories;

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _fetchDataFromApi();
    await _saveDataToDatabase();
    await _loadDataFromDatabase();
    notifyListeners();
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final data = await _apiService.fetchData();

      _categories = data
          .where((item) => item['type'] == 'categories')
          .expand((item) => (item['contents'] as List<dynamic>)
              .map((p) => CategoryModel.fromJson(p as Map<String, dynamic>)))
          .toList();

      _banners = data
          .where((item) => item['type'] == 'banner_slider')
          .expand((item) => (item['contents'] as List<dynamic>)
              .map((p) => BannerModel.fromJson(p as Map<String, dynamic>)))
          .toList();
      notifyListeners();

      _singleBanners = data
          .where((item) => item['type'] == 'banner_single')
          .map((item) => SingleBannerModel.fromJson(item))
          .toList();

      _feauturedproducts = data
          .where((item) =>
              item['type'] == 'products' && item['title'] == "Best Sellers")
          .expand((item) => (item['contents'] as List<dynamic>)
              .map((p) => ProductModel.fromJson({
                    ...p as Map<String, dynamic>,
                    'title': 'Best Sellers',
                  })))
          .toList();
      log('FEATURED PRODUCTS LENGTH: ${_feauturedproducts.length}');
      _popularproducts = data
          .where((item) =>
              item['type'] == 'products' && item['title'] == "Most Popular")
          .expand((item) => (item['contents'] as List<dynamic>)
              .map((p) => ProductModel.fromJson({
                    ...p as Map<String, dynamic>,
                    'title': 'Most Popular',
                  })))
          .toList();
      log('POPULAR PRODUCTS LENGTH: ${_feauturedproducts.length}');
      await _dbHelper.clearAllData();
    } catch (e) {
      debugPrint('Error fetching data from API: $e');
    }
  }

  Future<void> _saveDataToDatabase() async {
    try {
      for (var banner in _banners) {
        final imagePath = await saveImageToFileSystem(
            banner.imageUrl, 'banner_${banner.title}.png');
        await _dbHelper.insertBanner(banner, imagePath);
      }
      for (var singleBanner in _singleBanners) {
        final imagePath = await saveImageToFileSystem(
            singleBanner.imageUrl, 'single_banner_${singleBanner.title}.png');
        await _dbHelper.insertSingleBanner(singleBanner, imagePath);
      }
      for (var product in _popularproducts) {
        final imagePath = await saveImageToFileSystem(
            product.productImage, 'popular_product_${product.sku}.png');
        const productType = "Most Popular";
        await _dbHelper.insertProduct(product, productType, imagePath);
      }
      for (var product in _feauturedproducts) {
        // log('FEATURED PRODUCT LENGTH WHEN SAVING: ${_feauturedproducts.length}');
        final imagePath = await saveImageToFileSystem(
            product.productImage, 'featured_product_${product.sku}.png');
        const productType = "Best Sellers";
        log('Product path in featured: $imagePath');
        await _dbHelper.insertProduct(product, productType, imagePath);
      }
      for (var category in _categories) {
        final imagePath = await saveImageToFileSystem(
            category.imageUrl, 'category_${category.imageUrl}.png');
        await _dbHelper.insertCategory(category, imagePath);
      }
      debugPrint("Data saved to database");
    } catch (e) {
      debugPrint('Error saving data to database: $e');
    }
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      debugPrint('Loading data from database...');
      _banners = await _dbHelper.getBanners();
      notifyListeners();
      _singleBanners = await _dbHelper.getSingleBanners();
      notifyListeners();
      _popularproducts = await _dbHelper.getProducts("Most Popular");
      _feauturedproducts = await _dbHelper.getProducts("Best Sellers");
      // _categories = await _dbHelper.getCategories();

      // log('Loaded Banners: ${_banners[0].imageUrl}');
      log('Loaded Single Banners: ${_singleBanners.length}');
      log('Loaded Popular Products: ${_popularproducts.length}');
      log('Loaded Featured Products: ${_feauturedproducts.length}');
    } catch (e) {
      debugPrint('Error loading data from database: $e');
    }
  }
}
