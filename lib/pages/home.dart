import 'package:fixit/models/userModel.dart';
import 'package:fixit/pages/listJasa.dart';
import 'package:fixit/pages/profile.dart';
import 'package:fixit/services/auth.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter/material.dart';
import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fixit/providers/userProvider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

class HomeScreen extends ConsumerWidget {
  goToProfilePage(context) {
    Nav.goTo(context, UserProfile());
  }

  goToListJasaPage(context, idService, namaService) {
    Nav.goTo(context, ListJasa(idService: idService, namaService: namaService));
  }

  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // test(ref);
    AsyncValue<UserModel> user = ref.watch(userProvider);
    return ScrollLayout(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
      Row(
        children: [
          GestureDetector(
            onTap: () => {goToProfilePage(context)},
            child: const GFAvatar(
                backgroundImage: NetworkImage(
                    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/circular--1--1.png")),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20),
              child: user.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (data) {
                  return Text(
                    "Hello, ${data.name}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  );
                },
              )),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: TextField(
          controller: searchCont,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            labelText: "Search Appliances...",
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightBlueAccent[100],
          ),
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "Preferential",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("10% Save on your next saving!"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ElevatedButton(
                      onPressed: (() {}), child: Text("Receive")),
                )
              ]),
        ),
      ),
       Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Text("Home Appliances Repair",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: <Widget>[
                    CategoryTile(
                        callback: () =>
                            {goToListJasaPage(context, 1, "Air Conditioner")},
                        text: "Air Conditioner",
                        image: "assets/images/ac.png",
                        color: Colors.lightBlue[100]),
                    CategoryTile(
                        callback: () =>
                            {goToListJasaPage(context, 2, "Mesin Cuci")},
                        text: "Mesin Cuci",
                        image: "assets/images/mesincuci.png",
                        color: Colors.greenAccent[100])
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: <Widget>[
                    CategoryTile(
                        callback: () =>
                            {goToListJasaPage(context, 4, "Television")},
                        text: "Television",
                        image: "assets/images/tv.png",
                        color: Color.fromARGB(255, 90, 200, 250)),
                    CategoryTile(
                        callback: () =>
                            {goToListJasaPage(context, 3, "Kulkas")},
                        text: "Kulkas",
                        image: "assets/images/kulkas.png",
                        color: Colors.lightGreenAccent[100])
                  ],
                ),
              ),
            )
          ],
        ),
      )
    ]));
  }
}

class CategoryTile extends StatefulWidget {
  void Function() callback;
  String text;
  String image;
  Color? color;
  CategoryTile({
    required this.callback,
    this.color = Colors.blueAccent,
    required this.image,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => {widget.callback()},
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 200,
          decoration: BoxDecoration(
              color: widget.color, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Flexible(
                          child: Image.asset(
                        widget.image,
                        fit: BoxFit.fitHeight,
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
