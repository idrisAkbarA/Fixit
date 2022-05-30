import 'package:fixit/models/partnerModel.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/models/partnerModel.dart';

class PartnerProfile extends StatefulWidget {
  int partnerId;
  PartnerProfile({required this.partnerId, Key? key}) : super(key: key);

  @override
  State<PartnerProfile> createState() => _PartnerProfileState();
}

class _PartnerProfileState extends State<PartnerProfile> {
  Future<PartnerModel>? _partner;
  Future<PartnerModel> getPartner() async {
    var result = await Api.get(Endpoint.getPartner(widget.partnerId));
    print("[partner] ${result['data']['partner']}");
    return PartnerModel.fromJson(result['data']['partner']) ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _partner = getPartner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   label: const Text("Book Now"),
      //   icon: const Icon(Icons.bookmark_add),
      // ),
      appBar: AppBar(title: const Text("Penyedia Jasa")),
      body: FutureBuilder(
        future: _partner,
        builder: (
          BuildContext context,
          AsyncSnapshot<PartnerModel> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                  constraints: const BoxConstraints.expand(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const CircularProgressIndicator()],
                  ));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return  Text('Error ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Container(
              color: const Color.fromARGB(26, 187, 187, 187),
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/peoplebig.png"),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data?.name}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${snapshot.data?.address}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                RatingBar(
                                    ignoreGestures: true,
                                    updateOnDrag: false,
                                    itemSize: 25,
                                    initialRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                        full: const Icon(Icons.star,
                                            color: Colors.orange),
                                        half: const Icon(
                                          Icons.star_half,
                                          color: Colors.orange,
                                        ),
                                        empty: const Icon(
                                          Icons.star_outline,
                                          color: Colors.orange,
                                        )),
                                    onRatingUpdate: (value) {
                                      // setState(() {
                                      //   _ratingValue = value;
                                      // }
                                      // );
                                    }),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                                  Text("${snapshot.data?.description}"),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
