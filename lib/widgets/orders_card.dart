import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrdersCard extends StatelessWidget {
  const OrdersCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  SizedBox(
      height: size.height * .3,
      width: (size.width * .5) -30,
      child: Stack(
        children: [
          Positioned(
            top: size.height * .04,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10),
                // height: size.height * .2,
                width: (size.width * .5) - 30,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 6),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * .04,
                    ),
                    const Text(
                      'Ahmed Mohamed',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xff43494b),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    RatingBar.builder(
                      itemSize: 10,
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 4.0),
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    const Text(
                      '12 Nasr St.-Maddi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0x7843494b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    const Text(
                      '12 Minutes',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0x7843494b),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    const Text(
                      '40 SAR',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Color(0xffe44544),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                              width: (((size.width - 60) *
                                  .5) -
                                  30) *
                                  .5,
                              padding: const EdgeInsets
                                  .symmetric(
                                // horizontal: 10,
                                  vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF80AF50),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      24.0)),
                              child: const Text(
                                "Accept",
                                style: TextStyle(
                                    color: Colors.white),
                              )),
                          Container(
                            width: (((size.width - 60) *
                                .5) -
                                30) *
                                .5,
                            padding: const EdgeInsets
                                .symmetric(
                              // horizontal: 10,
                                vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: const Color(
                                    0xFFE44544),
                                borderRadius:
                                BorderRadius.circular(
                                    24.0)),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                // fontSize: 14,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * .08,
                width: size.height * .08,
                margin: const EdgeInsets.only(
                    bottom: 10.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFFE44544),
                        width: 1.5)),
                child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                        'assets/images/prof.jpg')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
