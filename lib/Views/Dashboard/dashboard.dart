import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shoppingcart/Controllers/ProductsController.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Models/Utils/Images.dart';
import 'package:shoppingcart/Models/Utils/Routes.dart';
import 'package:shoppingcart/Models/Utils/Utils.dart';
import 'package:shoppingcart/Views/Cart/Cart.dart';
import 'package:shoppingcart/Views/Dashboard/drawer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../sub-content/products-grid-view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductsController _productsController = ProductsController();
  List<dynamic> _products = [];

  Map<String, dynamic> filter = {};

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool isQr = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null &&
          scanData.code!.isNotEmpty &&
          scanData.code.toString().contains('CART_')) {
        String? scannedCode = scanData.code?.replaceAll('CART_', '');
        setState(() {
          isQr = false;
        });
        _productsController
            .createCart(context, scannedCode!)
            .then((value) => Routes(context: context).navigate(Cart(
                  products: [],
                )));
      }
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: color6,
      drawer: DashboardMenu(selection: 1),
      body: SafeArea(
          child: SizedBox(
        height: displaySize.height,
        width: displaySize.width,
        child: Column(
          children: [
            Expanded(
                flex: 0,
                child: Container(
                  decoration: BoxDecoration(color: color7),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_scaffoldKey.currentState!.hasDrawer &&
                                _scaffoldKey.currentState!.isEndDrawerOpen) {
                              _scaffoldKey.currentState!.closeEndDrawer();
                            } else {
                              _scaffoldKey.currentState!.openDrawer();
                            }
                          },
                          child: Icon(
                            Icons.menu,
                            color: colorPrimary,
                          ),
                        ),
                        SizedBox(
                            width: displaySize.width * 0.1,
                            child: Image.asset(logo)),
                        GestureDetector(
                          onTap: () async {
                            openShops();
                          },
                          child: Icon(
                            Icons.store,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: (isQr == false)
                    ? (_products.isNotEmpty)
                        ? ProductGridView(
                            products: _products,
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: colorPrimary.withOpacity(0.3),
                            ),
                          )
                    : QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: colorPrimary,
          onPressed: () {
            CustomUtils.showLoader(context);
            _productsController.getCartProducts(context).then((value) {
              CustomUtils.hideLoader(context);
              if (value != 2) {
                Routes(context: context).navigate(Cart(
                  products: value,
                ));
              } else {
                _productsController.createCart(context, '1').then((value) {
                  Routes(context: context).navigate(Cart(
                    products: [],
                  ));
                });

                // setState(() {
                //   isQr = true;
                // });
              }
            });
          },
          child: Icon(
            Icons.shopping_bag,
            color: color6,
          )),
    );
  }

  void getProducts() {
    _productsController.getProducts(context, filter).then((value) {
      setState(() {
        _products = value;
      });
    });
  }

  navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=w");
    if (await canLaunchUrlString(uri.toString())) {
      await launchUrlString(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  void openShops() {
    _productsController.getShops(context).then((dynamic value) {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Shops',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (filter.isNotEmpty) {
                            Routes(context: context).back();
                            setState(() {
                              filter = {};
                              getProducts();
                            });
                          }
                        },
                        child: Icon(
                          Icons.layers_clear,
                          color: (filter.isNotEmpty) ? colorPrimary : color8,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: color8,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: displaySize.height * 0.4,
                  child: Center(
                    child: ListView(
                      children: [for (var data in value) getShopCard(data)],
                    ),
                  ),
                )
              ],
            );
          });
    });
  }

  getShopCard(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Card(
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Routes(context: context).back();
                  setState(() {
                    filter = {'shop': data['id'].toString()};
                    getProducts();
                  });
                },
                child: Icon(
                  Icons.store,
                  color: colorPrimary,
                ),
              )
            ],
          ),
          title: GestureDetector(
            onTap: () {
              Routes(context: context).back();
              setState(() {
                filter = {'shop': data['id'].toString()};
                getProducts();
              });
            },
            child: Text(
              data['name'].toString(),
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
          ),
          subtitle: Text(
            data['address'].toString(),
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              GestureDetector(
                onTap: (){
                  navigateTo(double.parse(data['ltd'].toString()), double.parse(data['lng'].toString()));
                },
                child: Icon(
                Icons.navigation,
                color: color14,
              ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
