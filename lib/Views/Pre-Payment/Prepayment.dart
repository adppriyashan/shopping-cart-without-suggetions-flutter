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
import 'package:shoppingcart/Views/Pre-Payment/Payment.dart';
import 'package:shoppingcart/Views/Widgets/custom_button.dart';
import 'package:shoppingcart/Views/sub-content/products-grid-view.dart';

class PrePayment extends StatefulWidget {
  dynamic products;

  PrePayment({Key? key, this.products}) : super(key: key);

  @override
  State<PrePayment> createState() => _CartState(products: products);
}

class _CartState extends State<PrePayment> {
  List<dynamic> products = [];
  List<dynamic> suggesions = [];

  _CartState({required this.products});

  final ProductsController _productsController = ProductsController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getProducts();
    });
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
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: color9,
                                ),
                              ),
                              Center(
                                  child: Text(
                                "You've missed,",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: color6,
                                    fontSize: 16.0),
                              )),
                            ])))),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1 / 1.4,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0),
                        children: [
                          for (dynamic data in suggesions) getCard(data)
                        ],
                      ),
                    ))
              ],
            ),
            Positioned(
                bottom: 20.0,
                child: CustomButton(
                    buttonText: "No Thanks",
                    textColor: color6,
                    backgroundColor: colorPrimary,
                    isBorder: false,
                    borderColor: color6,
                    onclickFunction: () async {
                      FocusScope.of(context).unfocus();
                      CustomUtils.showLoader(context);
                      _productsController
                          .getCartProducts(context)
                          .then((value) {
                        CustomUtils.hideLoader(context);
                        products = value;
                        double price = 0.0;
                        products.forEach((element) {
                          price += double.parse(element['price'].toString());
                        });
                        Routes(context: context)
                            .navigate(ReservationPayment(total: price));
                      });
                    }))
          ],
        ),
      )),
    );
  }

  void getProducts() {
    _productsController.getCartSuggetions(context).then((value) {
      print(value);
      setState(() {
        suggesions.clear();
        suggesions = value;
      });
    });
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
                    'Available Qty : ${data['qty'].toString()}',
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
}
