import 'package:fixit/models/transactionModel.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrderDetailPage extends StatefulWidget {
  int transactionId;
  OrderDetailPage({required this.transactionId, Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Future<TransactionModel>? _transaction;
  Future<TransactionModel> getTransaction() async {
    try {
      var result = await Api.get(Endpoint.transaction(widget.transactionId));
      print("[transaction] $result");
      return TransactionModel.fromJson(result["data"]["transaction"]);
    } catch (e) {
      throw Exception("error ${e.toString()}");
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transaction = getTransaction();
  }
  
  String formatDateTime(DateTime date){
    return "Tanggal: ${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year.toString()}\nPukul: ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')} ";
  }
  void acceptOrder() async{
    try {
      var body = {
        "transaction_id": widget.transactionId.toString()
      };
      var result = await  Api.post(Endpoint.confirmOrder, body);
      setState(() {
        _transaction = getTransaction();
      });
    } catch (e) {
      print("$e");
    }
  }
  void rejectOrder() async{
    try {
      var body = {
        "transaction_id": widget.transactionId.toString()
      };
      var result = await  Api.post(Endpoint.rejectOrder, body);
      setState(() {
        _transaction = getTransaction();
      });
    } catch (e) {
      print("$e");
    }
  }
  void finishOrder() async{
    try {
      var body = {
        "transaction_id": widget.transactionId.toString()
      };
      var result = await  Api.post(Endpoint.finishOrder, body);
      setState(() {
        _transaction = getTransaction();
      });
    } catch (e) {
      print("$e");
    }
  }

  String setStatus(data) {
    if (data == "waiting") {
      return "Menunggu konfirmasi anda sebagai penyedia jasa.";
    } else if (data == "accepted") {
      return "Anda telah mengkonfirmasi pesanan ini. Silahkan menjalankan jasa anda.";
    } else if (data == "finished"){
      return "Pesanan telah selesai.";
    }
    else {
      return "Pesanan ini telah dibatalkan.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     bookService(_partner2?.partnerServiceModel[0].id);
      //   },
      //   label: const Text("Book Now"),
      //   icon: const Icon(Icons.bookmark_add),
      // ),
      appBar: AppBar(title: const Text("Order Detail")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FutureBuilder(
        future: _transaction,
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ){
           if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData && (snapshot.data?.isAccepted == "waiting")) {
              return Wrap(
          //will break to another line on overflow
          direction: Axis.horizontal, //use vertical to show  on vertical axis
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(10),
                child: FloatingActionButton.extended(
          onPressed: () {
            rejectOrder();
            // Nav.goTo(context, PartnerOrderListPage());
          },
          label: const Text("Tolak"),
          icon: const Icon(Icons.close),
          backgroundColor: Colors.red,
        )), //button first
      
            Container(
                margin: EdgeInsets.all(10),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    acceptOrder();
                    // Nav.goTo(context, PartnerOrderListPage());
                  },
                  label: const Text("Terima"),
                  icon: const Icon(Icons.check),
                  backgroundColor: Colors.green,
                )), // button second
      
            
      
            // Add more buttons here
          ],
        );
            } else if(snapshot.hasData && (snapshot.data?.isAccepted == "rejected")){
              return Container();
            }else if(snapshot.hasData && snapshot.data?.isAccepted == "finished"){
              return Container();
            }
            else {
              return FloatingActionButton.extended(
                  onPressed: () {
                    finishOrder();
                    // Nav.goTo(context, PartnerOrderListPage());
                  },
                  label: const Text("Tandai Order Sebagai Selesai"),
                  icon: const Icon(Icons.check),
                  backgroundColor: Colors.green,
                );
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
        
      ),
      body: FutureBuilder(
        future: _transaction,
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
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
              return Text('Error ${snapshot.error}');
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
                          padding: const EdgeInsets.only(
                              top: 50, left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reparasi: ${snapshot.data?.serviceModel?.name}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${snapshot.data?.partner?.name}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "Biaya Rp.${snapshot.data?.partnerServiceModel?.price}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  // RatingBar(
                                  //     ignoreGestures: true,
                                  //     updateOnDrag: false,
                                  //     itemSize: 25,
                                  //     initialRating: 0,
                                  //     direction: Axis.horizontal,
                                  //     allowHalfRating: true,
                                  //     itemCount: 5,
                                  //     ratingWidget: RatingWidget(
                                  //         full: const Icon(Icons.star,
                                  //             color: Colors.orange),
                                  //         half: const Icon(
                                  //           Icons.star_half,
                                  //           color: Colors.orange,
                                  //         ),
                                  //         empty: const Icon(
                                  //           Icons.star_outline,
                                  //           color: Colors.orange,
                                  //         )),
                                  //     onRatingUpdate: (value) {
                                  //       // setState(() {
                                  //       //   _ratingValue = value;
                                  //       // }
                                  //       // );
                                  //     }),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                    "Status:\n${setStatus(snapshot.data.isAccepted)}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                    "${formatDateTime(snapshot.data.date)}"),
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
