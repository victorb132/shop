import 'package:flutter/material.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        hintColor: Colors.deepOrange,
        useMaterial3: true,
        fontFamily: 'Lato',
      ),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen(),
      },
      home: ProductOverviewScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
