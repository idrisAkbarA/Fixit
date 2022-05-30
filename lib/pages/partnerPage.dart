import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartnerPage extends StatefulWidget {
  const PartnerPage({Key? key}) : super(key: key);

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  Future<bool>? _isAlreadyRegisteredAsPartner;
  Future<bool> checkIsUserRegisteredAsPartner() async{
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: partnerIdKey);
    if(data==null){
      return false;
    }else{
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
    return ScrollLayout(child: Container(
      constraints: BoxConstraints.expand(),
      child: Column(),
    ));
    
  }
}