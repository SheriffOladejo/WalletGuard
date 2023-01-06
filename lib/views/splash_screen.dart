import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:wallet_offline_guard/views/enter_passcode.dart';
import 'package:wallet_offline_guard/views/intro.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  DbHelper db = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#040405"),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        color: HexColor("#040405"),
        child: Center(
          child: Image.asset("assets/images/logo.png", width: 90, height: 90,)
          ),
        ),
      );
  }

  Future init() async {
    Future.delayed(const Duration(seconds: 2), () async {
      String passcode = await db.getPasscode();
      if(passcode == null || passcode.isEmpty){
        Navigator.of(context).pushReplacement(slideLeft(const Intro()));
      }
      else{
        Navigator.of(context).pushReplacement(slideLeft(EnterPasscode()));
      }

    });
  }

  @override
  void initState(){
    super.initState();
    init();
  }

}
