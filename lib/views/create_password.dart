import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:wallet_offline_guard/views/home_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class CreatePassword extends StatefulWidget {

  const CreatePassword({Key key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();

}

class _CreatePasswordState extends State<CreatePassword> {

  bool is_password_visible = false;
  bool is_password_focus = false;
  bool is_confirm_password_visible = false;
  bool is_confirm_password_focus = false;

  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();

  final form_key = GlobalKey<FormState>();
  DbHelper db = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form_key,
          child: Container(
            color:  HexColor("#040405"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Text(
                    "Welcome...",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'syne-extrabold',
                      color: Colors.white
                    ),
                  ),
                ),
                Container(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Text(
                    "Lets setup your master passcode",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'syne-bold',
                      color: Colors.white
                    ),
                  ),
                ),
                Container(height: 20,),
                FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        is_password_focus = !is_password_focus;
                      });
                    },
                    child: TextFormField(
                      validator: (val){
                        if(val != null){
                          return val.length < 4 ? "Passcode must contain at least 4 numbers" : null;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'publicsans-regular'
                      ),
                      controller: password_controller,
                      obscureText: !is_password_visible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            is_password_visible ? Icons.visibility : Icons.visibility_off,
                            color: is_password_focus ? Theme.of(context).primaryColorDark : Colors.grey,
                          ),
                          onPressed: (){
                            setState(() {
                              is_password_visible = !is_password_visible;
                            });
                          },
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'publicsans-regular',
                          fontSize: 16
                        ),
                        labelText: "Enter master passcode",
                          focusedBorder: focusedBorder(),
                          enabledBorder: enabledBorder(),
                          errorBorder: errorBorder()
                      ),
                    ),
                  ),
                ),
                Container(height: 20,),
                FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        is_confirm_password_focus = !is_confirm_password_focus;
                      });
                    },
                    child: TextFormField(
                      validator: (val){
                        if(val != null){
                          if(val.toString() != password_controller.text.toString()) {
                            return "Passcodes don't match!";
                          }
                          return null;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'publicsans-regular'
                      ),
                      controller: confirm_password_controller,
                      obscureText: !is_confirm_password_visible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              is_confirm_password_visible ? Icons.visibility : Icons.visibility_off,
                              color: is_confirm_password_focus ? Theme.of(context).primaryColorDark :
                              Colors.grey,
                            ),
                            onPressed: (){
                              setState(() {
                                is_confirm_password_visible = !is_confirm_password_visible;
                              });
                            },
                          ),
                          labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'publicsans-regular',
                              fontSize: 16
                          ),
                          labelText: "Confirm passcode",
                          focusedBorder: focusedBorder(),
                          enabledBorder: enabledBorder(),
                          errorBorder: errorBorder()
                      ),
                    ),
                  ),
                ),
                Container(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: MaterialButton(
                    onPressed: () async {
                      await savePasscode();
                    },
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    color: HexColor("#1541D7"),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Complete setup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'publicsans-regular'
                          ),
                        ),
                        Container(width: 5,),
                        Image.asset("assets/images/tick-circle.png", width: 20, height: 20,),
                      ],
                    ),
                  ),
                ),
                Container(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Before using this app, you can review Wallet Guard's ",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'publicsans-regular',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Text(
                              "privacy policy ",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'publicsans-regular',
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Text(
                            "and ",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'publicsans-regular',
                              color: Colors.white,
                            ),
                          ),
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
                            child: const Text(
                              "terms of use. ",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'publicsans-regular',
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> savePasscode() async {
    if(!form_key.currentState.validate()) {
      return;
    }
    bool result = await db.savePasscode(password_controller.text.toString());
    if(result) {
      showToast("Passcode saved");
      String s = password_controller.text.toString() + DateTime.now().millisecondsSinceEpoch.toString();
      String hash = sha256.convert(utf8.encode(s)).toString();
      print("create_password.savePasscode hash: $hash");
      await db.saveHash(hash);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

}
