import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';

class Backup extends StatefulWidget {

  @override
  State<Backup> createState() => _BackupState();

}

class _BackupState extends State<Backup> {

  TextEditingController key_controller = TextEditingController();
  String hash = "";
  DbHelper db = DbHelper();

  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
        centerTitle: true,
        title: const Text("Backup", style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'publisans-regular',
        ),),
      ),
      body: is_loading ? Center(
        child: CircularProgressIndicator(

        ),
      ) : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: HexColor("#040405"),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Keep this key in a safe place.\nIt's the only recovery by this app",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'publicsans-regular',
                ),
              ),
            ),
            Container(height: 20,),
            GestureDetector(
              onTap: () async {
                showToast("Key copied to clipboard");
                await Clipboard.setData(ClipboardData(text: hash));
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.white),
                ),
                child: const Text(
                  "COPY TO CLIPBOARD",
                  style: TextStyle(
                    fontFamily: 'publicsans-regular',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(height: 15,),
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
              enabled: false,
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
                hintText: ""
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future backup() async {
    setState(() {
      is_loading = true;
    });
    List<Wallet> wallets = await db.getWallets();
    for(int i = 0; i < wallets.length; i++) {
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("backups/$hash/$i");
      await ref.set({
        "id": wallets[i].id,
        "title": wallets[i].title,
        "twenty_four": wallets[i].twenty_four_words,
        "twelve": wallets[i].twelve_words,
        "private_key": wallets[i].private_key,
        "password": wallets[i].password,
        "note": wallets[i].note,
      });
      print("backup.backup backing up ${wallets[i].title}");
    }
    showToast("Wallets backed up");
    setState(() {
      is_loading = false;
    });
  }

  Future init() async {
    hash = await db.getHash();
    key_controller.text = hash;
    await backup();
    setState(() {

    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

}
