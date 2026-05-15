class InventoryItem {
  String name;
  String category; // ক্যাটাগরি ট্র্যাক করার জন্য নতুন ফিল্ড
  double purchasePrice;
  double sellingPrice;
  int stock;

  InventoryItem({
    required this.name,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
  });
}

class SaleRecord {
  final String itemName;
  final int quantity;
  final double totalAmount;
  final DateTime date;

  SaleRecord({
    required this.itemName,
    required this.quantity,
    required this.totalAmount,
    required this.date,
  });
}