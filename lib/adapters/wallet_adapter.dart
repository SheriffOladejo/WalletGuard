import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/views/add_wallet.dart';

class WalletAdapter extends StatefulWidget {

  Wallet wallet;
  Function callback;

  WalletAdapter({this.wallet, this.callback});

  @override
  State<WalletAdapter> createState() => _WalletAdapterState();

}

class _WalletAdapterState extends State<WalletAdapter> {

  DbHelper db = DbHelper();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Wallet w = Wallet(
          title: widget.wallet.title,
          twelve_words: widget.wallet.twelve_words,
          twenty_four_words: widget.wallet.twenty_four_words,
          id: -1,
          private_key: widget.wallet.private_key,
          password: widget.wallet.password,
          note: widget.wallet.note,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWallet(wallet: w,)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HexColor("#1C1C1C"),
          borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset("assets/images/home_wallet.png", width: 40, height: 40,),
                Container(width: 8,),
                Text(
                  widget.wallet.title,
                  style: const TextStyle(
                    fontFamily: 'publicsans-regular',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                showOptionsDialog(context);
              },
              child: const Icon(Icons.more_vert, color: Colors.white,)
            )
          ],
        ),
      ),
    );
  }

  showOptionsDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddWallet(callback: widget.callback, wallet: widget.wallet,)));
            },
            child: Container(
                alignment: Alignment.centerLeft,
                width: 300,
                height: 20,
                child: const Text("Edit                               ", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'publicsans-regular',
                  fontSize: 16,
                ),)
            ),
          ),
          Container(height: 20,),
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              await db.deleteWallet(widget.wallet);
              widget.callback();
            },
            child: Container(
                alignment: Alignment.centerLeft,
                width: 300,
                height: 20,
                child: const Text("Delete                               ", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'publicsans-regular',
                  fontSize: 16,
                ),)
            ),
          ),
        ],
      ),
    );
    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
