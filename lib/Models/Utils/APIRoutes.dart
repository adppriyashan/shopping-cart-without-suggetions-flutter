class APIRoutes {
  static const String _baseRoute = 'http://192.168.1.170:8001/api/';

  static String getRoute(String key) {
    switch (key) {
      case 'REGISTER':
        key = "${_baseRoute}auth/register";
        break;
      case 'LOGIN':
        key = '${_baseRoute}auth/login';
        break;
      case 'PRODUCTS_GET':
        key = '${_baseRoute}products/get';
        break;
      case 'CART_PRODUCTS_GET':
        key = '${_baseRoute}cart/products/get';
        break;
      case 'CART_PRODUCTS_REMOVE':
        key = '${_baseRoute}cart/products/remove';
        break;
      case 'CART_SUGGETIONS_PRODUCT_GET':
        key = '${_baseRoute}cart/products/suggetions';
        break;
      case 'CART_ADD':
        key = '${_baseRoute}cart/create';
        break;
      case 'SHOPS_GET':
        key = '${_baseRoute}shops/get';
        break;
      case 'DONE_PAYMENT':
        key = '${_baseRoute}cart/payment/done';
        break;
      case 'HISTORY':
        key = '${_baseRoute}cart/history/get';
        break;
    }
    return key;
  }
}
