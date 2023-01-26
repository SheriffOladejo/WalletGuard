import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:wallet_offline_guard/views/create_password.dart';

class Intro extends StatefulWidget {
  const Intro({Key key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#040405"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          color: HexColor("#040405"),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(height: 0,),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Secure storage",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'syne-extrabold',
                    color: Colors.white
                  ),
                ),
              ),
              Container(height: 15,),
              const Text(
                "Back up all cryptocurrency wallets locally and securely with "
                    "Wallet Guard",
                style: TextStyle(
                  fontFamily: 'syne-bold', color: Colors.white, fontSize: 16,
                ),
                softWrap: true,
              ),
              Container(height: 100,),
              Image.asset("assets/images/rafiki.png", height: 320, width: 430,),
              Container(height: 30,),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(slideLeft(const CreatePassword()));
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
                        "Let's go",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'publicsans-regular'
                        ),
                      ),
                      Container(width: 5,),
                      Image.asset("assets/images/login.png", width: 20, height: 20,),
                    ],
                  ),
                ),
              ),
              Container(height: 200,),
            ],
          ),
        ),
      ),
    );
  }

}
