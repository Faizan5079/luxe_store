import 'package:flutter/material.dart';
import 'package:luxe_store/features/products/models/product.dart';
import 'package:luxe_store/features/products/presentation/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> wishlistedProducts;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onWishlistTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.wishlistedProducts,
    required this.onProductTap,
    required this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('No products found')),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(
          product: product,
          isWishlisted: wishlistedProducts.contains(product.name),
          onTap: () => onProductTap(product),
          onWishlistTap: () => onWishlistTap(product),
        );
      },
    );
  }
}
