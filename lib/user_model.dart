class UserModel {
  String name;
  String rate;
  String quantity;
  String price;

  UserModel(
    this.name,
    this.rate,
    this.quantity,
    this.price,
  );

  //this is params branch

  UserModel.fromMap(dynamic obj) {
    this.rate = obj["rate"];
    this.name = obj["name"];
    this.quantity = obj["quantity"];
    this.price = obj["price"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = name;
    map["rate"] = rate;
    map["quantity"] = quantity;
    map["price"] = price;

    return map;
  }

  //Getters
  String get getrate => rate;
  String get getname => name;
  String get getprice => price;
  String get getquantity => quantity;
}
