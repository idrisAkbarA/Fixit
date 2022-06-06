import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/pages/partnerProfileSelf.dart';
import 'package:fixit/pages/registerAsPartner.dart';
import 'package:fixit/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartnerPage extends StatefulWidget {
  const PartnerPage({Key? key}) : super(key: key);

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  int partnerId = 0;
  Future<bool>? _isAlreadyRegisteredAsPartner;
  Future<bool> checkIsUserRegisteredAsPartner() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: partnerIdKey);
    print("[partner] $data");
    if (data == null) {
    print("[partner] false");
      return false;
    } else {
      partnerId = int.parse(data);
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAlreadyRegisteredAsPartner = checkIsUserRegisteredAsPartner();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isAlreadyRegisteredAsPartner,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return snapshot.data == true
                ? PartnerProfileSelf(partnerId: partnerId)
                : RegisterAsPartnerPage();
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
