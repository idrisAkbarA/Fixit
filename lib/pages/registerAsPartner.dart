import 'package:fixit/pages/partnerProfileSelf.dart';
import 'package:fixit/services/auth.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../layout/baseScrollLayout.dart';

class RegisterAsPartnerPage extends StatefulWidget {
  const RegisterAsPartnerPage({Key? key}) : super(key: key);

  @override
  State<RegisterAsPartnerPage> createState() => _RegisterAsPartnerPageState();
}

class _RegisterAsPartnerPageState extends State<RegisterAsPartnerPage> {
  TextEditingController namaTokoCont = TextEditingController();
  TextEditingController alamatCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController deskripsiCont = TextEditingController();

  void registerPartner(context) async{
    print("called");
    try {
      var result = await Auth.registerAsPartner(namaTokoCont.text, alamatCont.text, phoneCont.text, deskripsiCont.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PartnerProfileSelf(partnerId: result)));
      // Nav.goTo(context, PartnerProfileSelf(partnerId: result));
    } catch (e) {
      throw Exception("$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return  ScrollLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/logo.png', height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("Register now to join as Partner"),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Image.asset(
              'assets/images/illustration2.png',
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              controller: namaTokoCont,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: "Nama Toko",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              controller: alamatCont,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                labelText: "Alamat Toko",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              controller: phoneCont,
             
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                labelText: "Nomor Telepon",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              controller: deskripsiCont,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.text_fields),
                border: OutlineInputBorder(),
                labelText: "Deskripsi Toko Anda",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async{
                    registerPartner(context);
                  },
                  child: const Text("Register as Partner"),
                )),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, bottom: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text("Have an account?"),
          //       TextButton(
          //           onPressed: () {
          //             // Nav.goTo(context, Login());
          //           },
          //           child: const Text(
          //             "Login",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold, color: Colors.blue),
          //           ))
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}