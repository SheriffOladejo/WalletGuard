class Wallet {
  int id;
  String title;
  String password;
  String twelve_words;
  String twenty_four_words;
  String private_key;
  String note;
  String date_created;

  Wallet({
    this.id,
    this.title,
    this.password,
    this.twelve_words,
    this.twenty_four_words,
    this.private_key,
    this.note,
    this.date_created,
  });

  factory Wallet.fromMap(Map<dynamic, dynamic> map) {
    return Wallet(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      password: map['password'] ?? '',
      twelve_words: map['twelve'] ?? '',
      twenty_four_words: map['twenty_four'] ?? '',
      private_key: map['private_key'] ?? '',
      note: map['note'] ?? '',
    );
  }

  @override
  int compareTo(other) {
    var a = id;
    var b = other.id;

    if(b > a){
      return 1;
    }
    else if(a == b){
      return 0;
    }
    else{
      return -1;
    }
  }

}