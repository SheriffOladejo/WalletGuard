import 'package:flutter/material.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/db_helper.dart';
import 'package:wallet_offline_guard/utils/hex_color.dart';
import 'package:wallet_offline_guard/views/add_wallet.dart';
import 'package:wallet_offline_guard/adapters/wallet_adapter.dart';
import 'package:wallet_offline_guard/views/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Wallet> wallet_list = [];
  List<Wallet> search_list = [];
  bool is_searching = false;
  DbHelper db = DbHelper();

  TextEditingController search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#040405"),
        title: const Text(
          "Wallet saver",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'publicsans-regular'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
            },
            child: Image.asset(
              "assets/images/settings.png",
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          Container(width: 15,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddWallet(callback: callback,)));
        },
        backgroundColor: HexColor("#1541D7"),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
          color: HexColor("#040405"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(15),
          child: wallet_list.isEmpty ? emptyWallet() : walletList()),
    );
  }

  void callback() {
    init();
  }

  Widget emptyWallet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            "assets/images/pana.png",
            width: 300,
            height: 250,
          ),
          Container(
            height: 20,
          ),
          const Text(
            "There are no entries yet",
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'publicsans-regular',
                color: Colors.white),
          )
        ],
      )
    );
  }

  Future<void> filterWallets() async {
    String search_string = search_controller.text.toString().toLowerCase().trim();
    search_list = [];
    for(var i = 0; i<wallet_list.length; i++){
      Wallet w = wallet_list[i];
      if(w.title.toLowerCase().contains(search_string)){
        search_list.add(w);
      }
    }
    if(search_list.isNotEmpty){
      setState(() {
        is_searching = true;
      });
    }
    else{
      setState(() {
        is_searching = true;
      });
    }
  }

  Future<void> init() async {
    wallet_list = await db.getWallets();
    wallet_list.sort((a, b) {
      return a.compareTo(b);
    });
    setState(() {

    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Widget walletList() {
    return Column(
      children: [
        Container(height: 30,),
        TextFormField(
          validator: (val) {
            if (val != null) {
              return val.isEmpty ? "Empty search string" : null;
            }
            return null;
          },
          onChanged: (val) {
            filterWallets();
          },
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'publicsans-regular'),
          controller: search_controller,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: GestureDetector(
              onTap: () {
                filterWallets();
              },
              child: Image.asset(
                "assets/images/search.png",
                width: 24,
                height: 24,
              ),
            ),
            labelStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'publicsans-regular',
                fontSize: 16),
            labelText: "Search",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: HexColor("#1541D7"),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Container(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: const Text(
            "My wallets",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'publicsans-regular',
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: is_searching ? search_list.length : wallet_list.length,
            shrinkWrap: false,
            itemBuilder: (context, index) {
              Wallet w = is_searching ? search_list[index] : wallet_list[index];
              return WalletAdapter(wallet: w, callback: callback,);
            },
          ),
        )
      ],
    );
  }

}
