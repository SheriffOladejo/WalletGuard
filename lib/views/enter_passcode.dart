import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:wallet_offline_guard/views/home_screen.dart';

class EnterPasscode extends StatefulWidget {

  @override
  State<EnterPasscode> createState() => _EnterPasscodeState();
}

class _EnterPasscodeState extends State<EnterPasscode> {
  bool is_password_visible = false;
  bool is_password_focus = false;

  TextEditingController password_controller = TextEditingController();

  final form_key = GlobalKey<FormState>();
  DbHelper db = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
      ),
      body: Form(
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
                  "Welcome back",
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
                  "Please enter your master passcode",
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
                        return val.isEmpty ? "Required" : null;
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
                        labelText: "Passcode",
                        focusedBorder: focusedBorder(),
                        enabledBorder: enabledBorder(),
                        errorBorder: errorBorder()
                    ),
                  ),
                ),
              ),
              Container(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(75, 10, 75, 10),
                child: MaterialButton(
                  onPressed: () async {
                    await login();
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
                        "Done",
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
            ],
          ),
        ),
      ),
    );
  }

  Future login () async {
    if(!form_key.currentState.validate()) {
      return;
    }
    String passcode = await db.getPasscode();
    String _pass = password_controller.text.toString();
    if(passcode == _pass) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    else{
      showToast("Incorrect passcode");
    }
  }

}
