import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingcart/Controllers/ProductsController.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _CartState();
}

class _CartState extends State<History> {
  List<dynamic> carts = [];

  final ProductsController _productsController = ProductsController();

  @override
  void initState() {
    super.initState();
    getData();
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
                                "History",
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
                      child: ListView(
                        children: [for (dynamic data in carts) getCard(data)],
                      ),
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }

  void getData() {
    _productsController.getHistory(context).then((value) {
      setState(() {
        carts.clear();
        carts = value;
      });
    });
  }

  getCard(data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.inventory_outlined)],
          ),
          title: Text(
            data['formatTotal'].toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500, color: color13, fontSize: 14.0),
          ),
          subtitle: Text(
            data['formatDate'].toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500, color: color3, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
