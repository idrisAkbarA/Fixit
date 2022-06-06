import 'dart:async';
import 'dart:convert';

import 'package:fixit/models/partnerOrderModel.dart';
import 'package:fixit/models/transactionModel.dart';
import 'package:fixit/pages/OrderDetailPage.dart';
import 'package:fixit/pages/transactionPage.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/constants.dart';
import 'package:fixit/util/endpoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/getwidget.dart';
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';
import 'package:fixit/Pusher/pusher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../util/route.dart';

class PartnerOrderListPage extends StatefulWidget {
  const PartnerOrderListPage({Key? key}) : super(key: key);

  @override
  State<PartnerOrderListPage> createState() => _PartnerOrderListPageState();
}

class _PartnerOrderListPageState extends State<PartnerOrderListPage> {
  
  late Future<List<PartnerOrderModel>> _orderlist;
  Future<List<PartnerOrderModel>> _getOrderList() async {
    final storage = new FlutterSecureStorage();
    var partnerId = await storage.read(key: partnerIdKey);
    var result = await Api.get(Endpoint.partnerTransactionHistory(partnerId));
    print("[result]\n${result['data']}");
    var finalResult = List<PartnerOrderModel>.from( result["data"]["transactions"].map((x)=>PartnerOrderModel.fromJson(x)));
      print("\n\n[result] ${finalResult.toString()}\n\n");
      return finalResult;

  }
  String formatDateTime(DateTime date){
    return "Tanggal: ${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year.toString()}\nPukul: ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')} ";
  }

  void refreshData(){
    setState(() {
      _orderlist = _getOrderList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderlist = _getOrderList();
  }
  

  @override
  Widget build(BuildContext context) {
    // var test = PusherService();
    // LaravelFlutterPusher pusher = test.initPusher("8a8025c6f9e9e3742733", "192.168.1.16", 6001, "ap1");
    // dynamic data;
    // StreamController<dynamic> controller = StreamController<dynamic>();
    // Stream stream = controller.stream;

    // /// Subscribe to Channel

    // pusher.subscribe("partner.1").bind("new-order", (event) {
    //   print(event);
    //   controller.add(event);
    // });
    return Scaffold(
      appBar: AppBar( title: Text("List Order Reparasi")),
      body: SafeArea(
        child: FutureBuilder(
          future: _orderlist,
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
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          // print("\nPartner id ${snapshot.data[index]['partner']["id"]} | service id ${snapshot.data[index]['service']["id"]}");
                          // Nav.goTo(context, OrderDetailPage(transactionId: snapshot.data[index].id));
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailPage(transactionId: snapshot.data[index].id))).then((value) => refreshData());
                          },
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
                                      Text("Pesanan untuk reparasi:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
                                      Text("${snapshot.data[index].service?.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                        child: Text(formatDateTime(snapshot.data[index].date), style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                        child: Text("Status: ${snapshot.data[index].isAccepted}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
                                      ),
                                      // Text(snapshot.data[index]['partner']['address'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
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