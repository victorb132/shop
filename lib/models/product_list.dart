import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/shop_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([this._token = '', this._items = const [], this._userId = '']);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.userFavoritesUrl}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;

      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'].toString() : Random().nextDouble().toString(),
      name: data['name'].toString(),
      description: data['description'].toString(),
      price: double.parse(data['price'].toString()),
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProuct(product);
    }
  }

  Future<void> addProuct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw ShopException(
          msg: 'Ocorreu um erro na exclusão do produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
