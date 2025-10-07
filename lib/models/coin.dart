class Coin {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double quantity;

  const Coin({
    this.id = '',
    this.symbol = '',
    this.name = '',
    this.price = 0.0,
    this.quantity = 0.0,
  });

  Coin copyWith({
    String? id,
    String? symbol,
    String? name,
    double? price,
    double? quantity,
  }) {
    return Coin(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  static const Coin defaults = Coin();

  factory Coin.fromMap(Map<String, dynamic> data) {
    final d = Coin.defaults;

    return Coin(
      id: data['id'] ?? d.id,
      symbol: data['symbol'] ?? d.symbol,
      name: data['name'] ?? d.name,
      price: data['price'] ?? d.price,
      quantity: data['quantity'] ?? d.quantity,
    );
  }
}
