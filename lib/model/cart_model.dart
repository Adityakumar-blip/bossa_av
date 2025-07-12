/* class Cart {
  int? restaurantId;
  String? promoCode = "";
  double discount = 0.00;
  double deliveryFee = 0.00;
  double subTotal() => _calcSubTotal();
  double total = 0.00;
  int hiddenTotal() =>
      ((this.subTotal() - this.discount + this.deliveryFee) * 100).toInt();
  List<Item> items = [];

  removeItem(int index) {
    items.removeAt(index);
  }

  double _calcSubTotal() {
    double total = 0;
    for (int i = items.length - 1; i == 0; --i) {
      total += (items[i].price * items[i].quantity);
    }
    return total;
  }

  addItem(Item item) {
    items.add(item);
  }
}

class Item {
  int id = 0;
  String plu = "";
  double price = 0;
  int hiddenPrice() => (this.price * 100).toInt();
  int quantity = 0;
  String item = "";
  List<Option> options = [];

  Item(this.id, this.plu, this.price, this.quantity, this.item, this.options);
}

class Option {
  int id = 0;
  String plu = "";
  String item = "";
  int price = 0;

  Option(this.id, this.item, this.plu, this.price);
}
 */