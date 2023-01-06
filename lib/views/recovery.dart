import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';

class Recovery extends StatefulWidget {


  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {

  bool is_loading = false;
  TextEditingController key_controller = TextEditingController();

  DbHelper db = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
        centerTitle: true,
        title: const Text("Recovery", style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'publisans-regular',
        ),),
      ),
      body: is_loading ? Center(
        child: CircularProgressIndicator(

        ),
      ) :  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: HexColor("#040405"),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Alert! After recovery, you will lose the current wallets and is"
                    "replaced with your new wallets",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'publicsans-regular',
                ),
              ),
            ),
            Container(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: const Text(
                "Key",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'publicsans-regular',
                ),
              ),
            ),
            Container(height: 8,),
            TextFormField(
              controller: key_controller,
              style: const TextStyle(
                  fontFamily: 'publicsans-regular',
                  fontSize: 16,
                  color: Colors.white
              ),
              minLines: 5,
              maxLines: 7,
              decoration: InputDecoration(
                  enabledBorder: enabledBorder(),
                  focusedBorder: focusedBorder(),
                  errorBorder: errorBorder(),
                  disabledBorder: disabledBorder(),
                  hintStyle: const TextStyle(
                      fontFamily: 'publicsans-regular',
                      fontSize: 16,
                      color: Colors.grey
                  ),
                  hintText: "Paste key here"
              ),
            ),
            Container(height: 10,),
            MaterialButton(
              onPressed: () async {
                await recover();
              },
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              color: HexColor("#1541D7"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40), // <-- Radius
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Recover",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'publicsans-regular'
                    ),
                  ),
                  Container(width: 5,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future recover() async {
    setState(() {
      is_loading = true;
    });
    String hash = key_controller.text.toString();
    final snapshot = await FirebaseDatabase.instance.ref().child('backups/$hash').get();
    List<Wallet> list = [];

    final map = snapshot.value as List<Object>;
    print("map ${map.toString()}");

    for(int i = 0; i < map.length; i++) {
      Map<Object, Object> m = map[i];
      Wallet w = Wallet(
        id: m["id"],
        title: m["title"],
        note: m["note"],
        password: m["password"],
        twenty_four_words: m["twenty_four"],
        twelve_words: m["twelve"],
        private_key: m["private_key"],
      );
      await db.saveWallet(w);
    }

    showToast("Recovery finished");
    setState(() {
      is_loading = false;
    });
  }

}
