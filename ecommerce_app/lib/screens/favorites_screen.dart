import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/favorites_provider.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();

    // Empty favorites state
    if (favProvider.favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: const Center(
          child: Text('No favorite products yet!'),
        ),
      );
    }

    // Favorites grid
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: favProvider.favorites.length,
        itemBuilder: (context, index) {
          final product = favProvider.favorites[index];

          return ProductCard(
            productName: product['name'],
            price: (product['price'] as num).toDouble(),
            imageUrl: product['imageUrl'],
            description: product['description'] ?? '',
            isFavorite: true, // all items here are favorite
            onFavoriteToggle: () {
              // Remove from favorites
              context.read<FavoritesProvider>().toggleFavorite(
                product['id'],
                product,
              );
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productData: product,
                    productId: product['id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
