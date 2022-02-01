// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zonedriver/app/constants.dart';
import 'package:zonedriver/app/silvergrid_ratio.dart';
import 'package:zonedriver/widgets/orders_card.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.whiteAppColor,
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            Container(
              height: size.height * .22,
              width: size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60.0),
                  bottomRight: Radius.circular(60.0),
                ),
                color: Color(0xffe44544),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/images/menu3.svg",
                      color: Colors.white,
                      height: size.height * 0.05,
                      width: size.height * 0.05,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      'Order Requests',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color(0xffffffff),
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * .78,
              child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: const [
                        Text(
                          'Hello Ahmed,',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            color: Color(0xe543494b),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: const [
                        Text(
                          'Our customers wait their orders quickly ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Color(0x9943494b),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  GridView.builder(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      height: size.height * .3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return const OrdersCard();
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
