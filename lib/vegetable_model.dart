class Vegetable {
  final String uid;
  final String name;
  final double price;
  double totalPrice;
  double qty;
  double ogQty;

  set total(double total) {
    this.totalPrice = total;
  }

  set quantity(double qty) {
    this.qty = qty;
  }

  set ogStock(double qty) {
    this.ogQty = qty;
  }

  double get total => totalPrice;

  double get ogStock => ogQty;

  Vegetable({this.uid, this.name, this.price, this.qty, this.ogQty});
}