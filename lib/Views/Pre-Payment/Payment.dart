import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingcart/Controllers/ProductsController.dart';
import 'package:shoppingcart/Models/Strings/reservation.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Models/Utils/Images.dart';
import 'package:shoppingcart/Models/Utils/Routes.dart';
import 'package:shoppingcart/Models/Utils/Utils.dart';
import 'package:shoppingcart/Models/Validation/FormValidation.dart';
import 'package:shoppingcart/Views/Dashboard/dashboard.dart';
import 'package:shoppingcart/Views/Widgets/custom_button.dart';
import 'package:shoppingcart/Views/Widgets/custom_date_selector.dart';
import 'package:shoppingcart/Views/Widgets/custom_text_form_field.dart';

class ReservationPayment extends StatefulWidget {
  dynamic total;

  ReservationPayment({Key? key, required this.total}) : super(key: key);

  @override
  State<ReservationPayment> createState() =>
      // ignore: no_logic_in_create_state
      _ReservationPaymentState(total: total);
}

class _ReservationPaymentState extends State<ReservationPayment> {
  dynamic total;
  _ReservationPaymentState({required this.total});

  final ProductsController _productsController = ProductsController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: color6,
        body: SafeArea(
            child: SizedBox(
          height: displaySize.height,
          width: displaySize.width,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(color: colorPrimary),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0, bottom: 15.0),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: color9,
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              reservation_confirmation.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: color6,
                                  fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 60.0),
                          child: Image.asset(paymentTypes),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: CustomTextFormField(
                              readOnly: false,
                              height: 5.0,
                              controller: TextEditingController(),
                              backgroundColor: color7,
                              iconColor: color3,
                              isIconAvailable: true,
                              hint: reservation_card_no.toUpperCase(),
                              icon: Icons.email_outlined,
                              textInputType: TextInputType.text,
                              validation: (value) =>
                                  FormValidation.notEmptyValidation(value, ''),
                              obscureText: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: CustomTextFormField(
                              readOnly: false,
                              height: 5.0,
                              controller: TextEditingController(),
                              backgroundColor: color7,
                              iconColor: color3,
                              isIconAvailable: true,
                              hint: reservation_card_holder_name.toUpperCase(),
                              icon: Icons.email_outlined,
                              textInputType: TextInputType.text,
                              validation: (value) =>
                                  FormValidation.notEmptyValidation(value, ''),
                              obscureText: false),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomDateSelectorWithImage(
                                    height: 5.0,
                                    backgroundColor: color7,
                                    isIconAvailable: true,
                                    hint: reservation_card_expire_date_month
                                        .toUpperCase(),
                                    icon_img: Icons.calendar_month,
                                    onConfirm: () {},
                                    type: CustomDateSelectorWithImage
                                        .DATE_SELECTOR,
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      readOnly: false,
                                      height: 5.0,
                                      controller: TextEditingController(),
                                      backgroundColor: color7,
                                      iconColor: color3,
                                      isIconAvailable: true,
                                      hint: reservation_card_cvv.toUpperCase(),
                                      icon: Icons.email_outlined,
                                      textInputType: TextInputType.text,
                                      validation: (value) =>
                                          FormValidation.notEmptyValidation(
                                              value, ''),
                                      obscureText: false),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton(
                              buttonText:
                                  "$reservation_card_pay(LKR ${double.parse(total.toString()).toStringAsFixed(2)})",
                              textColor: color6,
                              backgroundColor: colorPrimary,
                              isBorder: false,
                              borderColor: color6,
                              onclickFunction: () async {
                                FocusScope.of(context).unfocus();
                                CustomUtils.showLoader(context);
                                _productsController
                                    .doPayment(context)
                                    .then((value) {
                                  CustomUtils.hideLoader(context);
                                  Routes(context: context)
                                      .navigateReplace(const Dashboard());
                                });
                              }),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
