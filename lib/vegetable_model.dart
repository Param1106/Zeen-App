class Vegetable {
  final String uid;
  final String name;
  final int price;
  int qty;

  set quantity(int qty) {
    this.qty = qty;
  }

  Vegetable({this.uid, this.name, this.price, this.qty});
}