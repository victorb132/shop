class ShopException implements Exception {
  final String msg;
  final int statusCode;

  ShopException({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
