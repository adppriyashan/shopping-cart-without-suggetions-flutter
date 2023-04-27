import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingcart/Controllers/ProductsController.dart';
import 'package:shoppingcart/Models/Strings/dashboard.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Models/Utils/Routes.dart';
import 'package:shoppingcart/Models/Utils/Utils.dart';
import 'package:shoppingcart/Views/Dashboard/product.dart';
import 'package:shoppingcart/Views/Pre-Payment/Prepayment.dart';
import 'package:shoppingcart/Views/Widgets/custom_button.dart';

import '../sub-content/products-grid-view.dart';

class Cart extends StatefulWidget {
  dynamic products;

  Cart({Key? key, this.products}) : super(key: key);

  @override
  State<Cart> createState() => _CartState(products: products);
}

class _CartState extends State<Cart> {
  List<dynamic> products = [];

  _CartState({required this.products});

  final ProductsController _productsController = ProductsController();

  Timer? timer;

  String total = '';

  @override
  void initState() {
    super.initState();
    getProducts();
    initializeLive();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color6,
      body: SafeArea(
          child: SizedBox(
        height: displaySize.height,
        width: displaySize.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                    flex: 0,
                    child: Container(
                        decoration: BoxDecoration(color: colorPrimary),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 18.0,
                                bottom: 15.0),
                            child: Stack(children: [
                              GestureDetector(
                                onTap: () {
                                  timer!.cancel();
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: color9,
                                ),
                              ),
                              Center(
                                  child: Text(
                                (total != '') ? total : cart_title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: color6,
                                    fontSize: 16.0),
                              )),
                            ])))),
                Expanded(
                    flex: 1,
                    child: (products.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.4,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0),
                              children: [
                                for (dynamic data in products) getCard(data)
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              cart_empty,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: color8,
                                  fontSize: 16.0),
                            ),
                          ))
              ],
            ),
            (products.isNotEmpty)
                ? Positioned(
                    bottom: 20.0,
                    child: CustomButton(
                        buttonText: "Confirm Cart",
                        textColor: color6,
                        backgroundColor: colorPrimary,
                        isBorder: false,
                        borderColor: color6,
                        onclickFunction: () async {
                          FocusScope.of(context).unfocus();
                          Routes(context: context).navigate(PrePayment(
                            products: products,
                          ));
                        }))
                : const SizedBox.shrink()
          ],
        ),
      )),
    );
  }

  getCard(data) {
    return GestureDetector(
      onTap: () {
        Routes(context: context).navigate(ProductPage(
          productData: data,
        ));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color9)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: displaySize.width * 0.4,
                        width: displaySize.width * 0.4,
                        child: CachedNetworkImage(
                          imageUrl: data['img'].toString(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            _productsController.deleteCartProduct(context, {
                              'id': data['cartid'].toString()
                            }).then((value) {
                              getProducts();
                              CustomUtils.showSnackBarMessage(context,
                                  "Cart Updated", CustomUtils.SUCCESS_SNACKBAR);
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: color12,
                          ),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    (data['name'].toString().length < 18)
                        ? data['name'].toString()
                        : '${data['name'].toString().substring(0, 18)}..',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Qty : ${data['qty'].toString()}',
                    style: const TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    data['formatPrice'].toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: colorPrimary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getProducts() {
    _productsController.getCartProducts(context).then((value) {
      products.clear();
      products = (value != 2) ? value : [];
      if (products.isNotEmpty) {
        total = products[0]['total_price'];
      }
      setState(() {});
    });
  }

  void initializeLive() {
    timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => getProducts());
  }
}
