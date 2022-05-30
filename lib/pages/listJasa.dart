import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/pages/bookingPage.dart';
import 'package:fixit/pages/partnerProfile.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../util/endpoint.dart';

class ListJasa extends StatefulWidget {
  int idService;
  String namaService;
  ListJasa({required this.idService, required this.namaService, Key? key})
      : super(key: key);

  @override
  State<ListJasa> createState() => _ListJasaState();
}

class _ListJasaState extends State<ListJasa> {
  Future<List<dynamic>>? _jasa;
  Future<List<dynamic>> getJasa(idService) async {
    var result = await Api.get(Endpoint.getServices(idService));
    print("[service] $result");
    print("[service] ${result.runtimeType}");

    return result['data']['partners'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _jasa = getJasa(widget.idService);
    // print("[service] ${_jasa.runtimeType}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text(widget.namaService)),
      body: SafeArea(
        child: FutureBuilder(
          future: _jasa,
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return  Text('Error ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => {Nav.goTo(context, BookingPage(partnerId: snapshot.data[index]["id"], serviceId: snapshot.data[index]["partner_service"][0]["service"]['id'] ,))},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: const GFAvatar(
                                        size: 50,
                                        backgroundImage: NetworkImage(
                                            "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/circular--1--1.png")),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index]['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                      Text(snapshot.data[index]['address'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0),
                                        child: RatingBar(
                                          ignoreGestures: true,
                                          updateOnDrag: false,
                                          itemSize: 20,
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            elevation: 5,
                          ),
                        ),
                      );
                    });
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
