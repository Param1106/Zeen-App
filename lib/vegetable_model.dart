class Vegetable {
  final String uid;
  final String name;
  final double price;
  double totalPrice;
  double qty;

  set quantity(double qty) {
    this.qty = qty;
  }

  set total(double total) {
    this.totalPrice = total;
  }

  double get total => totalPrice;

  Vegetable({this.uid, this.name, this.price, this.qty});
}