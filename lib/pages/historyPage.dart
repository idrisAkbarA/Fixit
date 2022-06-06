
import 'dart:convert';

import 'package:fixit/models/transactionModel.dart';
import 'package:fixit/models/userModel.dart';
import 'package:fixit/pages/transactionPage.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../util/endpoint.dart';
import '../util/route.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List<TransactionModel>>? _transactionsHistory;
  Future<List<TransactionModel>> getTransactionHistory() async {
    final storage = new FlutterSecureStorage();
    var userRawJson = await storage.read(key: userDataKey);
    UserModel user;
    try {
      if (userRawJson == null) {
        throw Exception("User is not exist!");
      }
      user = UserModel.fromJson(jsonDecode(userRawJson));
      var result = await Api.get(Endpoint.transactionHistory(user.id));
      print("[result] ${result['data']}");
      var finalResult = List<TransactionModel>.from( result["data"]["transactions"].map((x)=>TransactionModel.fromJson(x)));
      print("\n\n[result] ${finalResult.toString()}\n\n");
      return finalResult;
    } catch (e) {
      throw Exception("something went wrong ${e.toString()}");
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionsHistory = getTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("History")),
      body: SafeArea(
        child: FutureBuilder(
          future: _transactionsHistory,
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
                          Nav.goTo(context, TransactionPage(transactionId: snapshot.data[index].id));
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
                                      Text("${snapshot.data[index].serviceModel?.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                      Text("${snapshot.data[index].partner?.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                        child: Text("Status: ${snapshot.data[index].isAccepted}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
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
