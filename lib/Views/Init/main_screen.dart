import 'package:flutter/material.dart';
import 'package:shoppingcart/Models/Strings/main_screen.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Views/Auth/register.dart';
import 'package:shoppingcart/Views/Auth/login.dart';
import '../../Models/Utils/Images.dart';
import '../../Models/Utils/Routes.dart';
import '../Widgets/custom_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<DateTime> selectedDates = [];

  @override
  Widget build(BuildContext context) {
    print(selectedDates);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color3,
      body: SizedBox(
          height: displaySize.height,
          width: displaySize.width,
          child: Stack(
            // height: displaySize.height * 0.5,
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: SizedBox(
                width: displaySize.width,
                height: displaySize.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: color3,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          colorPrimary.withOpacity(0.2), BlendMode.dstATop),
                      image: AssetImage(mainScreenBg),
                    ),
                  ),
                  child: const Text(
                    '',
                  ),
                ),
              )),
              Positioned(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40.0, top: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          mainQuote1,
                          style: TextStyle(color: color9, fontSize: 40.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          mainQuote2,
                          style: TextStyle(color: color9, fontSize: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          mainQuote3,
                          style: TextStyle(color: color9, fontSize: 40.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          mainQuote4,
                          style: TextStyle(color: color9, fontSize: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          mainQuote5,
                          style: TextStyle(color: color9, fontSize: 60.0),
                        ),
                      )
                    ],
                  ),
                ),
              )),
              Positioned(
                  bottom: displaySize.height * 0.02,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45.0, vertical: 5.0),
                        child: CustomButton(
                            buttonText: SignUp_title,
                            textColor: color6,
                            backgroundColor: colorPrimary,
                            isBorder: false,
                            borderColor: color6,
                            onclickFunction: () {
                              Routes(context: context)
                                  .navigate(BusinessRegister());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45.0, vertical: 5.0),
                        child: CustomButton(
                            buttonText: Login_title,
                            textColor: color3,
                            backgroundColor: color6,
                            isBorder: true,
                            borderColor: color3,
                            onclickFunction: () {
                              Routes(context: context).navigate(const Login());
                            }),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
