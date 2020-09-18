class Vegetable {
  final String uid;
  final String name;
  final double price;
  double qty;

  set quantity(double qty) {
    this.qty = qty;
  }

  Vegetable({this.uid, this.name, this.price, this.qty});
}