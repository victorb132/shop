import 'package:flutter/material.dart';
import 'package:shop/components/product_grid.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Somente Favoritos'),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  // productsContainer.showFavoriteOnly();
                  _showFavoriteOnly = true;
                } else if (selectedValue == FilterOptions.all) {
                  // productsContainer.showAll();
                  _showFavoriteOnly = false;
                } else {}
              });
            },
          )
        ],
      ),
      body: Container(
        color: Colors.purple[100],
        child: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
      ),
    );
  }
}
