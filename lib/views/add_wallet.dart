import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/utils/methods.dart';

class AddWallet extends StatefulWidget {

  Wallet wallet;
  Function callback;
  AddWallet({this.wallet, this.callback});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {

  TextEditingController title_controller = TextEditingController();
  TextEditingController passcode_controller = TextEditingController();
  TextEditingController phrase_controller = TextEditingController();
  TextEditingController note_controller = TextEditingController();

  List<TextEditingController> twelve_controller_list = [];
  List<TextEditingController> twenty_four_controller_list = [];

  bool is_passcode_focus = false;
  bool is_passcode_visible = false;

  bool is_viewing = false;
  bool is_editing = false;

  bool is_12_selected = true;
  bool is_24_selected = false;
  bool is_private_key_selected = false;

  final form_key = GlobalKey<FormState>();

  DbHelper db = DbHelper();

  Future<void> addWallet() async {
    if(is_24_selected) {
      String concat_words = "";
      for(int i = 0; i < 24; i++) {
        String word = "${twenty_four_controller_list[i].text} ";
        if(twenty_four_controller_list[i].text.toString().isNotEmpty) {
          concat_words += word;
        }
      }
      setState(() {
        phrase_controller.text = concat_words;
      });
    }
    else if(is_12_selected) {
      String concat_words = "";
      for(int i = 0; i < 12; i++) {
        String word = "${twelve_controller_list[i].text} ";
        if(twelve_controller_list[i].text.toString().isNotEmpty) {
          concat_words += word;
        }
      }
      setState(() {
        phrase_controller.text = concat_words;
      });
    }
    if(!form_key.currentState.validate()) {
      return;
    }
    String phrase = phrase_controller.text.toString();
    String concat_words = "";
    Wallet w = Wallet(
      title: title_controller.text.toString().trim(),
      password: passcode_controller.text.toString(),
      note: note_controller.text.toString().trim(),
      date_created: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    if(widget.wallet != null && !is_viewing) {
      w.private_key = widget.wallet.private_key;
      w.twenty_four_words = widget.wallet.twenty_four_words;
      w.twelve_words = widget.wallet.twelve_words;
    }

    if(is_24_selected) {
      int count = 0;
      for(int i = 0; i < 24; i++) {
        String word = "${twenty_four_controller_list[i].text} ";
        if(twenty_four_controller_list[i].text.toString().isNotEmpty) {
          count++;
          concat_words += word;
        }
      }
      if(count < 24) {
        showToast("Incomplete number of words");
        return;
      }
      else{
        w.twenty_four_words = concat_words;
      }
    }
    else if(is_12_selected) {
      int count = 0;
      for(int i = 0; i < 12; i++) {
        String word = "${twelve_controller_list[i].text} ";
        if(twelve_controller_list[i].text.toString().isNotEmpty) {
          count++;
          concat_words += word;
        }
      }
      if(count < 12) {
        showToast("Incomplete number of words");
        return;
      }
      else{
        w.twelve_words = concat_words;
      }
    }
    else if(is_private_key_selected) {
      w.private_key = phrase;
    }

    if(widget.wallet != null && widget.wallet.id != -1) {
      w.id = widget.wallet.id;

      bool result = await db.updateWallet(w);
      if(result) {
        showToast("Wallet updated");
        widget.callback();
        Navigator.pop(context);
      }
    }
    else{
      bool result = await db.saveWallet(w);
      if(result) {
        showToast("Wallet saved");
        widget.callback();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          is_viewing ? "Viewing wallet" : is_editing ? "Edit wallet" : "Add wallet",
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'publicsans-regular',
            color: Colors.white,
          ),
        ),
        backgroundColor: HexColor("#040405"),
      ),
      body: Form(
        key: form_key,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(15),
          color: HexColor("#040405"),
          child: CustomScrollView(
            slivers: [
              SliverList(delegate: SliverChildListDelegate([
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Title",
                    style: TextStyle(
                      fontFamily: 'publicsans-regular',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(height: 8,),
                TextFormField(
                  validator: (val){
                    if(val != null){
                      if(val.toString().isEmpty) {
                        return "Required";
                      }
                      return null;
                    }
                    return null;
                  },
                  enabled: !is_viewing,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'publicsans-regular'
                  ),
                  controller: title_controller,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'publicsans-regular',
                        fontSize: 16
                    ),
                    hintText: "Any title...",
                    hintStyle: const TextStyle(
                        fontFamily: 'publicsans-regular',
                        fontSize: 16,
                        color: Colors.grey
                    ),
                    focusedBorder: focusedBorder(),
                    enabledBorder: enabledBorder(),
                    errorBorder: errorBorder(),
                    disabledBorder: disabledBorder()
                  ),
                ),
                Container(height: 15,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'publicsans-regular',
                    ),
                  ),
                ),
                Container(height: 8,),
                FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        is_passcode_focus = !is_passcode_focus;
                      });
                    },
                    child: TextFormField(
                      validator: (val){
                        if(val != null){
                          if(val.toString().isEmpty) {
                            return "Required";
                          }
                          return null;
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'publicsans-regular'
                      ),
                      enabled: !is_viewing,
                      controller: passcode_controller,
                      obscureText: !is_passcode_visible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            is_passcode_visible ? Icons.visibility : Icons.visibility_off,
                            color: is_passcode_focus ? Theme.of(context).primaryColorDark : Colors.grey,
                          ),
                          onPressed: (){
                            setState(() {
                              is_passcode_visible = !is_passcode_visible;
                            });
                          },
                        ),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'publicsans-regular',
                            fontSize: 16
                        ),
                        hintText: "Passcode",
                        hintStyle: const TextStyle(
                            fontFamily: 'publicsans-regular',
                            fontSize: 16,
                            color: Colors.grey
                        ),
                        focusedBorder: focusedBorder(),
                        enabledBorder: enabledBorder(),
                        errorBorder: errorBorder(),
                        disabledBorder: disabledBorder()
                      ),
                    ),
                  ),
                ),
                Container(height: 20,),
              ])),
              SliverList(delegate: SliverChildListDelegate([
                selector(),
                Container(height: 20,),
              ])),
              SliverList(delegate: SliverChildListDelegate([
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    is_private_key_selected ? "Private key" : "Auto arrange",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'publicsans-regular',
                    ),
                  ),
                ),
                Container(height: 8,),
                TextFormField(
                  controller: phrase_controller,
                  style: const TextStyle(
                      fontFamily: 'publicsans-regular',
                      fontSize: 16,
                      color: Colors.white
                  ),
                  validator: (val) {
                    if(val != null) {
                      if(val.isEmpty) {
                        return "Phrase cannot be empty";
                      }
                    }
                    return null;
                  },
                  enabled: !is_viewing,
                  onChanged: (value) {
                    List<String> words = value.split(" ");
                    if(words.isNotEmpty) {
                      for(int i = 0; i < words.length; i++){
                        if(is_24_selected) {
                          if(i < 24) {
                            twenty_four_controller_list[i].text = words[i];
                          }
                        }
                        else if(is_12_selected) {
                          if(i < 12) {
                            twelve_controller_list[i].text = words[i];
                          }
                        }
                      }
                      setState(() {

                      });
                    }
                  },
                  minLines: 6,
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
                      hintText: is_private_key_selected ? "" : "Paste words here for auto-arrange..."
                  ),
                ),
                Container(height: 8,),
              ])),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3/1
                ),
                delegate: SliverChildListDelegate(
                  listSelector(),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate([
                Container(height: 8,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Note",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'publicsans-regular',
                    ),
                  ),
                ),
                Container(height: 8,),
                TextFormField(
                  controller: note_controller,
                  style: const TextStyle(
                      fontFamily: 'publicsans-regular',
                      fontSize: 16,
                      color: Colors.white
                  ),
                  minLines: 5,
                  maxLines: 7,
                  enabled: !is_viewing,
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
                      hintText: "Write anything you like..."
                  ),
                ),
              ]),),
              SliverList(delegate: SliverChildListDelegate([
                Container(height: 8,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                  child: is_viewing ? Container() : MaterialButton(
                    onPressed: () async {
                      await addWallet();
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
                          "Save",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'publicsans-regular'
                          ),
                        ),
                        Container(width: 5,),
                        Image.asset("assets/images/save.png", width: 20, height: 20,),
                      ],
                    ),
                  ),
                ),
                Container(height: 8,)
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Future init() async {
    for(int i = 0; i < 24; i++) {
      if(i < 12) {
        twelve_controller_list.add(TextEditingController());
      }
      twenty_four_controller_list.add(TextEditingController());
    }
    if(widget.wallet != null && widget.wallet.id == -1) {
      is_viewing = true;
    }
    else if(widget.wallet != null && widget.wallet.id != -1){
      is_editing = true;
    }
    if(widget.wallet != null) {
      title_controller.text = widget.wallet.title;
      passcode_controller.text = widget.wallet.password;
      note_controller.text = widget.wallet.note;
    }
    if(is_12_selected && widget.wallet != null && widget.wallet.twelve_words != "null") {
      phrase_controller.text = widget.wallet.twelve_words;
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Widget> listSelector() {
    if(is_24_selected) {
      return twentyFourList();
    }
    else if(is_12_selected) {
      return twelveList();
    }
    else if(is_private_key_selected) {
      if(widget.wallet != null && widget.wallet.private_key != "null") {
      }
    }
    return [Container()];
  }

  Widget selector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              phrase_controller.text = "";
              is_12_selected = !is_12_selected;
              is_24_selected = false;
              is_private_key_selected = false;
              if(is_12_selected && widget.wallet != null && widget.wallet.twelve_words != "null") {
                phrase_controller.text = widget.wallet.twelve_words;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: is_12_selected ? Colors.grey : Colors.transparent,
              border: Border.all(color: Colors.grey)
            ),
            child: const Text(
              "12 words",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'publicsans-regular',
                fontSize: 12,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              phrase_controller.text = "";
              is_12_selected = false;
              is_24_selected = !is_24_selected;
              is_private_key_selected = false;
              if(is_24_selected && widget.wallet != null && widget.wallet.twenty_four_words != "null") {
                phrase_controller.text = widget.wallet.twenty_four_words;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
                color: is_24_selected ? Colors.grey : Colors.transparent,
                border: const Border.symmetric(horizontal : BorderSide(color: Colors.grey))
            ),
            child: const Text(
              "24 words",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'publicsans-regular',
                fontSize: 12,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              phrase_controller.text = "";
              is_12_selected = false;
              is_24_selected = false;
              is_private_key_selected = !is_private_key_selected;
              if(is_private_key_selected && widget.wallet != null && widget.wallet.private_key != "null") {
                phrase_controller.text = widget.wallet.private_key;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
                color: is_private_key_selected ? Colors.grey : Colors.transparent,
                border: Border.all(color: Colors.grey)
            ),
            child: const Text(
              "Private key",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'publicsans-regular',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> twentyFourList() {
    if(widget.wallet != null && widget.wallet.twenty_four_words != "null") {
      List<String> words = phrase_controller.text.split(" ");
      for(int i = 0; i < 24; i++) {
        print("add_Wallet.twentyFourList words: $words");
        twenty_four_controller_list[i].text = words[i];
      }
    }

    List<Widget> field_list = [];

    for(int i = 0; i < 24; i++) {
      field_list.add(
      Padding(
        padding: i % 2 == 0 ? const EdgeInsets.fromLTRB(0, 5, 5, 5) : const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: TextFormField(
          autocorrect: false,
          enableSuggestions: false,
          enabled: !is_viewing,
          controller: twenty_four_controller_list[i],
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'publicsans-regular',
            fontSize: 12,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(10, 17, 0, 17),
              child: Text(
                "${i + 1}. ",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'publicsans-regular',
                  fontSize: 12,
                ),
              ),
            ),
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            disabledBorder: disabledBorder(),
            errorBorder: errorBorder(),
          ),
        ),
      ));
    }

    return field_list;
  }

  List<Widget> twelveList() {
    if(widget.wallet != null && widget.wallet.twelve_words != "null") {
      List<String> words = phrase_controller.text.split(" ");
      for(int i = 0; i < 12; i++) {
        twelve_controller_list[i].text = words[i];
      }
    }

    List<Widget> field_list = [];

    for(int i = 0; i < 12; i++) {
      field_list.add(
          Padding(
            padding: i % 2 == 0 ? const EdgeInsets.fromLTRB(0, 5, 5, 5) : const EdgeInsets.fromLTRB(5, 5, 0, 5),
            child: TextFormField(
              autocorrect: false,
              controller: twelve_controller_list[i],
              textAlign: TextAlign.start,
              enableSuggestions: false,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'publicsans-regular',
                fontSize: 12,
              ),
              enabled: !is_viewing,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 17, 0, 17),
                  child: Text(
                    "${i + 1}. ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'publicsans-regular',
                      fontSize: 12,
                    ),
                  ),
                ),
                enabledBorder: enabledBorder(),
                focusedBorder: focusedBorder(),
                disabledBorder: disabledBorder(),
                errorBorder: errorBorder(),
              ),
            ),
          ));
    }

    return field_list;
  }

}
