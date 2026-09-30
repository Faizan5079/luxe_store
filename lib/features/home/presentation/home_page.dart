import 'package:flutter/material.dart';
import 'package:luxe_store/features/cart/presentation/cart_page.dart';
import 'package:luxe_store/features/products/data/product_data.dart';
import 'package:luxe_store/features/products/presentation/product_details_page.dart';
import 'package:luxe_store/features/products/models/product.dart';
import 'widgets/category_list.dart';
import 'widgets/product_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Men', 'Women', 'Accessories'];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Featured';
  final Set<String> _wishlist = {};
  final List<Product> _cart = [];

  List<Product> get _filteredProducts {
    var result = products.toList();

    if (_selectedCategory != 'All') {
      result = result
          .where(
            (product) =>
                product.category.toLowerCase() ==
                _selectedCategory.toLowerCase(),
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    switch (_sortBy) {
      case 'Price: Low to High':
        result.sort(
          (a, b) => (double.tryParse(a.price) ?? 0).compareTo(
            double.tryParse(b.price) ?? 0,
          ),
        );
        break;
      case 'Price: High to Low':
        result.sort(
          (a, b) => (double.tryParse(b.price) ?? 0).compareTo(
            double.tryParse(a.price) ?? 0,
          ),
        );
        break;
      case 'Top Rated':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LUXE',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        'Discover your style',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Shopping cart',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CartPage(
                                cartItems: _cart,
                                onRemove: (product) {
                                  setState(() {
                                    _cart.remove(product);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        icon: Badge(
                          label: Text('${_cart.length}'),
                          isLabelVisible: _cart.isNotEmpty,
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_wishlist.length} items in your wishlist',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF292929),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Style that speaks.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Explore the latest collection.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CategoryList(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our Products',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Featured',
                        child: Text('Featured'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: Low to High',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: High to Low',
                        child: Text('Price: High to Low'),
                      ),
                      DropdownMenuItem(
                        value: 'Top Rated',
                        child: Text('Top Rated'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortBy = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ProductGrid(
                products: filteredProducts,
                wishlistedProducts: _wishlist,
                onProductTap: (product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        product: product,
                        onAddToCart: () {
                          setState(() => _cart.add(product));
                        },
                      ),
                    ),
                  );
                },
                onWishlistTap: (product) {
                  setState(() {
                    if (!_wishlist.add(product.name)) {
                      _wishlist.remove(product.name);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
