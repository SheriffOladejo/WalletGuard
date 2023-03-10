import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/views/backup.dart';
import 'package:wallet_offline_guard/views/recovery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_offline_guard/utils/methods.dart';

class Settings extends StatefulWidget {

  const Settings({Key key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();

}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
        centerTitle: true,
        title: const Text("Settings", style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'publisans-regular',
        ),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        color: HexColor("#040405"),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Backup()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: HexColor("#1C1C1C"),
                  borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/backup.png", width: 24, height: 24, color: Colors.white,),
                    Container(width: 10,),
                    const Text("Backup my wallets", style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'publicsans-regular'
                    ),),
                  ],
                ),
              ),
            ),
            Container(height: 16,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Recovery()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: HexColor("#1C1C1C"),
                    borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/recovery.png", width: 24, height: 24, color: Colors.white,),
                    Container(width: 10,),
                    const Text("Recover my wallets", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'publicsans-regular'
                    ),),
                  ],
                ),
              ),
            ),
            Container(height: 16,),
            GestureDetector(
              onTap: () async {
                var url = "https://lukka.tech/privacy-policy/";
                if(await canLaunch(url)){
                  await launch(url);
                }
                else{
                  showToast("Cannot launch URL");
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: HexColor("#1C1C1C"),
                    borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/privacy_policy.png", width: 24, height: 24, color: Colors.white,),
                    Container(width: 10,),
                    const Text("Privacy policy", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'publicsans-regular'
                    ),),
                  ],
                ),
              ),
            ),
            Container(height: 16,),
            GestureDetector(
              onTap: () async {
                var url = "https://lukka.tech/terms-of-use/";
                if(await canLaunch(url)){
                  await launch(url);
                }
                else{
                  showToast("Cannot launch URL");
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: HexColor("#1C1C1C"),
                    borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/terms_of_service.png", width: 24, height: 24, color: Colors.white,),
                    Container(width: 10,),
                    const Text("Terms of use", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'publicsans-regular'
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
