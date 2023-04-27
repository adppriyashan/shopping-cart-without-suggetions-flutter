import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Models/Utils/Routes.dart';
import 'package:shoppingcart/Views/Dashboard/product.dart';

class ProductGridView extends StatefulWidget {
  final dynamic products;

  const ProductGridView({super.key, required this.products});

  @override
  // ignore: no_logic_in_create_state
  State<ProductGridView> createState() => _ProductGridViewState(products: products);
}

class _ProductGridViewState extends State<ProductGridView> {
  final dynamic products;

  _ProductGridViewState({required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.4,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0),
        children: [for (dynamic data in products) getCard(data)],
      ),
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
