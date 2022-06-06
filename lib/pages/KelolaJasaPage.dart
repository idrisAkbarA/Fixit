import 'package:fixit/models/partnerServiceModel.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';
import '../util/constants.dart';

class KelolaJasaPage extends StatefulWidget {
  const KelolaJasaPage({Key? key}) : super(key: key);

  @override
  State<KelolaJasaPage> createState() => _KelolaJasaPageState();
}

class _KelolaJasaPageState extends State<KelolaJasaPage> {
  final _services = [
    "Mesin Cuci",
    "Air Conditioner",
    "Television",
    "Kulkas",
  ];
  late Future<List<PartnerServiceModel>> _partnerServices;
  Future<List<PartnerServiceModel>> getPartnerServices() async {
    try {
      final storage = new FlutterSecureStorage();
      var idPartner = await storage.read(key: partnerIdKey);
      var result = await Api.get(Endpoint.getPartnerServices(idPartner));
      print("[kelola jasa]$result");
      var finalResult = List<PartnerServiceModel>.from(result["data"]
              ["services"]
          .map((x) => PartnerServiceModel.fromJson(x)));

      return finalResult;
    } catch (e) {
      throw Exception("$e");
    }
  }

  String? _currentSelectedValue;
  TextEditingController namaTokoCont = TextEditingController();

  tambahJasa() async {
    var serviceId = 0;
    if (_currentSelectedValue == "Air Conditioner") serviceId = 1;
    if (_currentSelectedValue == "Mesin Cuci") serviceId = 2;
    if (_currentSelectedValue == "Kulkas") serviceId = 3;
    if (_currentSelectedValue == "Television") serviceId = 4;
    try {
      var body = {
        "price": namaTokoCont.text.toString(),
        "service_id": serviceId.toString(),
      };
      var result =
          await Api.post(Endpoint.storePartnerServices, body, useToken: true);

      setState(() {
        _partnerServices = getPartnerServices();
      });
    } catch (e) {
      throw Exception("$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _partnerServices = getPartnerServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kelola"),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     // bookService(_partner2?.partnerServiceModel[0].id, context);
        //   },
        //   label: const Text("Book Now"),
        //   icon: const Icon(Icons.bookmark_add),
        // ),
        body: Column(
          children: [
            Flexible(
                flex: 4,
                child: Container(
                  color: Color.fromARGB(26, 189, 189, 189),
                  constraints: BoxConstraints.expand(),
                  child: FutureBuilder(
                    future: _partnerServices,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PartnerServiceModel>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            constraints: BoxConstraints.expand(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (snapshot.hasData) {
                          return snapshot.data!.isEmpty
                              ? Text("No data currently")
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // print("\nPartner id ${snapshot.data[index]['partner']["id"]} | service id ${snapshot.data[index]['service']["id"]}");
                                        // Nav.goTo(context, TransactionPage(transactionId: snapshot.data[index].id));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GFListTile(
                                            titleText:
                                                'Jasa Reparasi: ${snapshot.data?[index].service?.name}',
                                            subTitleText:
                                                'Biaya Rp.${snapshot.data?[index].price}',
                                            icon: Icon(Icons.favorite)),
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
                )),
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10), //border corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                    //you can set more BoxShadow() here
                  ],
                ),
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.home_repair_service),
                                  labelText: "Jasa",
                                  hintText: 'Please select expense',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              isEmpty: _currentSelectedValue == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedValue,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _currentSelectedValue = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _services.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: namaTokoCont,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.money),
                              border: OutlineInputBorder(),
                              labelText: "Price",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () async {
                                  tambahJasa();
                                  // var isSuccess = await Auth.register(nameCont.text, emailCont.text, passwordCont.text, passwordConfirmCont.text);
                                  // if(isSuccess) {
                                  // await Auth.login(emailCont.text, passwordCont.text);
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MainLayout() ));
                                  // }
                                },
                                child: const Text("Tambah Jasa"),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
