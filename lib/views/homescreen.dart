import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacmachinetest/model/category_model.dart';
import 'package:wacmachinetest/model/product_model.dart';
import 'package:wacmachinetest/viewmodels/data_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.banners.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.banners.length,
                    itemBuilder: (context, index) {
                      final banner = viewModel.banners[index];
                      return _buildBannerImage(banner.imageUrl);
                    },
                  ),
                );
              },
            ),

            // Most Popular Section
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Most Popular',
                // style: Theme.of(context).textTheme.headline6,
              ),
            ),
            // Consumer<HomeViewModel>(
            //   builder: (context, viewModel, child) {
            //     if (viewModel.popularproducts.isEmpty) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     return SizedBox(
            //       height: 150, // Adjust the height as needed
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: viewModel.feauturedproducts.length,
            //         itemBuilder: (context, index) {
            //           final product = viewModel.feauturedproducts[index];
            //           return _buildProductCard(product, context);
            //         },
            //       ),
            //     );
            //   },
            // ),

            // Single Banner Section
            Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.singleBanners.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: viewModel.singleBanners.map((singleBanner) {
                    return _buildBannerImage(singleBanner.imageUrl);
                  }).toList(),
                );
              },
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Consumer<HomeViewModel>(
            //   builder: (context, viewModel, child) {
            //     if (viewModel.categories.isEmpty) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     return SizedBox(
            //       height: 100, // Adjust the height as needed
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: viewModel.categories.length,
            //         itemBuilder: (context, index) {
            //           final category = viewModel.categories[index];
            //           return _buildCategoryCard(category, context);
            //         },
            //       ),
            //     );
            //   },
            // ),

            // Featured Products Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Featured Products',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.popularproducts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: viewModel.feauturedproducts.length,
                  itemBuilder: (context, index) {
                    log('Product Length: ${viewModel.feauturedproducts.length}');
                    final product = viewModel.feauturedproducts[index];
                    return _buildProductCard(product, context);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation bar item tap
        },
      ),
    );
  }

  Widget _buildBannerImage(String imageUrl) {
    // log('Build banner image: $imageUrl');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        // child: Text('data'),
        // child: Image.file(File(imageUrl)),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.file(File(imageUrl)),
        ),
        // child: Image.network(imageUrl),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, BuildContext context) {
    log('Build Product Card Image: ${product.productImage}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product.productImage,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.file(File(product.productImage)),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.productName,
                // style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${product.offerPrice} (${product.discount})',
                // style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: CachedNetworkImage(
              imageUrl: category.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.title,
            // style: Theme.of(context).textTheme.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
