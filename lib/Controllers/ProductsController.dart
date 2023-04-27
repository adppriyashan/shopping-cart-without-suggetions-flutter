import 'package:dio/dio.dart';
import 'package:shoppingcart/Controllers/Common/HttpController.dart';
import 'package:shoppingcart/Models/Utils/APIRoutes.dart';
import 'package:shoppingcart/Models/Utils/JsonResponse.dart';
import 'package:shoppingcart/Models/Utils/Utils.dart';

class ProductsController {
  final HttpController _httpController = HttpController();

  Future<dynamic> getProducts(context, Map<String, dynamic> data) async {
    dynamic _listResp = [];
    await _httpController
        .doGet(APIRoutes.getRoute('PRODUCTS_GET'), {}, data)
        .then((Response response) async {
      _listResp = JsonResponse.fromJson(response.data).data;
    });

    return _listResp;
  }

  Future<dynamic> getShops(context) async {
    CustomUtils.showLoader(context);
    dynamic _listResp = [];
    await _httpController.doGet(APIRoutes.getRoute('SHOPS_GET'), {}, {}).then(
        (Response response) async {
      CustomUtils.hideLoader(context);
      _listResp = JsonResponse.fromJson(response.data).data;
    });

    return _listResp;
  }

  Future<dynamic> getCartProducts(context) async {
    dynamic _data = [];
    await _httpController.doGet(APIRoutes.getRoute('CART_PRODUCTS_GET'), {}, {
      'user': CustomUtils.getUser().id.toString()
    }).then((Response response) async {
      _data = JsonResponse.fromJson(response.data).data;
    });

    return _data;
  }

  Future<dynamic> getCartSuggetions(context) async {
    dynamic data = [];
    CustomUtils.showLoader(context);
    await _httpController.doGet(
        APIRoutes.getRoute('CART_SUGGETIONS_PRODUCT_GET'), {}, {
      'user': CustomUtils.getUser().id.toString()
    }).then((Response response) async {
      CustomUtils.hideLoader(context);
      data = JsonResponse.fromJson(response.data).data;
    });
    return data;
  }

  Future<dynamic> createCart(context, String cart) async {
    dynamic _data = [];
    await _httpController.doGet(APIRoutes.getRoute('CART_ADD'), {}, {
      'user': CustomUtils.getUser().id.toString(),
      'cart': cart,
    }).then((Response response) async {
      _data = JsonResponse.fromJson(response.data).data;
    });
    return _data;
  }

  Future<dynamic> doPayment(context) async {
    dynamic _data = [];
    await _httpController.doGet(APIRoutes.getRoute('DONE_PAYMENT'), {}, {
      'user': CustomUtils.getUser().id.toString(),
    }).then((Response response) async {
      _data = JsonResponse.fromJson(response.data).data;
    });
    return _data;
  }

  Future<void> deleteCartProduct(context, data) async {
    data['user'] = CustomUtils.getUser().id.toString();
    await _httpController
        .doGet(APIRoutes.getRoute('CART_PRODUCTS_REMOVE'), {}, data)
        .then((Response response) async {
    });
  }

  Future<dynamic> getHistory(context) async {
    dynamic _data = [];
    await _httpController.doGet(APIRoutes.getRoute('HISTORY'), {}, {
      'user': CustomUtils.getUser().id.toString(),
    }).then((Response response) async {
      _data = JsonResponse.fromJson(response.data).data;
    });
    return _data;
  }
}
