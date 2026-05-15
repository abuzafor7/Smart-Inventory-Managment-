import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab = 0;
  String _selectedCategory = "ALL"; // ডিফল্টভাবে সব আইটেম দেখাবে

  // আপনার দেওয়া সব আইটেম ক্যাটাগরি অনুযায়ী সাজানো হলো
  final List<InventoryItem> _items = [
    // CHICKEN
    InventoryItem(name: "Hot & Crispy Chicken", category: "CHICKEN", purchasePrice: 120.0, sellingPrice: 179.0, stock: 40),
    InventoryItem(name: "Smokey Red Chicken", category: "CHICKEN", purchasePrice: 120.0, sellingPrice: 179.0, stock: 35),

    // DEALS
    InventoryItem(name: "12pc + 6pc Free Bucket", category: "DEALS", purchasePrice: 1200.0, sellingPrice: 1799.0, stock: 15),
    InventoryItem(name: "10pc + 5pc Bucket", category: "DEALS", purchasePrice: 1000.0, sellingPrice: 1499.0, stock: 20),
    InventoryItem(name: "House Party Combo", category: "DEALS", purchasePrice: 700.0, sellingPrice: 999.0, stock: 25),

    // BURGERS
    InventoryItem(name: "Classic Zinger Burger", category: "BURGERS", purchasePrice: 220.0, sellingPrice: 329.0, stock: 30),
    InventoryItem(name: "Super Charger Burger", category: "BURGERS", purchasePrice: 210.0, sellingPrice: 320.0, stock: 25),
    InventoryItem(name: "Spicy Zinger Burger", category: "BURGERS", purchasePrice: 240.0, sellingPrice: 359.0, stock: 20),
    InventoryItem(name: "Mexican Salsa Burger", category: "BURGERS", purchasePrice: 260.0, sellingPrice: 399.0, stock: 15),

    // BOX MEALS
    InventoryItem(name: "Zinger Box", category: "BOX MEALS", purchasePrice: 380.0, sellingPrice: 529.0, stock: 18),
    InventoryItem(name: "Toasted Twister Box", category: "BOX MEALS", purchasePrice: 380.0, sellingPrice: 529.0, stock: 12),
    InventoryItem(name: "Rice Box", category: "BOX MEALS", purchasePrice: 200.0, sellingPrice: 319.0, stock: 30),

    // SNACKS
    InventoryItem(name: "Hot Wings (Per pc)", category: "SNACKS", purchasePrice: 40.0, sellingPrice: 60.0, stock: 100),
    InventoryItem(name: "Chicken Strips (Per pc)", category: "SNACKS", purchasePrice: 60.0, sellingPrice: 90.0, stock: 80),
    InventoryItem(name: "Fries Large", category: "SNACKS", purchasePrice: 100.0, sellingPrice: 199.0, stock: 50),
    InventoryItem(name: "Fries Medium", category: "SNACKS", purchasePrice: 80.0, sellingPrice: 179.0, stock: 60),
    InventoryItem(name: "Tangy Fries Large", category: "SNACKS", purchasePrice: 120.0, sellingPrice: 219.0, stock: 45),
    InventoryItem(name: "Potato Wedges", category: "SNACKS", purchasePrice: 110.0, sellingPrice: 189.0, stock: 40),
    InventoryItem(name: "Rizo Rice", category: "SNACKS", purchasePrice: 70.0, sellingPrice: 129.0, stock: 35),

    // BEVERAGES
    InventoryItem(name: "Pepsi 500ml", category: "BEVERAGES", purchasePrice: 35.0, sellingPrice: 50.0, stock: 120),
    InventoryItem(name: "7UP 500ml", category: "BEVERAGES", purchasePrice: 35.0, sellingPrice: 50.0, stock: 100),
    InventoryItem(name: "Water 500ml", category: "BEVERAGES", purchasePrice: 15.0, sellingPrice: 50.0, stock: 150),

    // DIPS
    InventoryItem(name: "Spicy Mayo", category: "DIPS", purchasePrice: 15.0, sellingPrice: 29.0, stock: 200),
    InventoryItem(name: "Nashville Sauce", category: "DIPS", purchasePrice: 15.0, sellingPrice: 29.0, stock: 180),
  ];

  final List<SaleRecord> _sales = [];

  // ক্যাটাগরির নামের লিস্ট (ফিল্টার করার জন্য)
  final List<String> _categories = ["ALL", "CHICKEN", "DEALS", "BURGERS", "BOX MEALS", "SNACKS", "BEVERAGES", "DIPS"];

  void _showActionDialog(InventoryItem item) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Current Stock: ${item.stock}"),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Quantity/Amount",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              int amount = int.tryParse(quantityController.text) ?? 0;
              if (amount > 0) {
                setState(() {
                  item.stock += amount;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${item.name} stock updated (+ $amount)")),
                );
              }
            },
            child: const Text("Stock Update", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              int qty = int.tryParse(quantityController.text) ?? 0;
              if (qty > 0 && item.stock >= qty) {
                setState(() {
                  item.stock -= qty;
                  _sales.add(SaleRecord(
                    itemName: item.name,
                    quantity: qty,
                    totalAmount: (qty * item.sellingPrice),
                    date: DateTime.now(),
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$qty ${item.name} Sold!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid quantity or Out of stock!"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Sell Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetTodaySales() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Today's Sales?"),
        content: const Text("Are you sure you want to clear today's total sales and report history?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _sales.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Today's sales have been reset!"), backgroundColor: Colors.orange),
              );
            },
            child: const Text("Yes, Reset", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  double _calculateTodaySales() {
    return _sales.fold(0.0, (sum, item) => sum + item.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Control"),
        centerTitle: true,
        backgroundColor: Colors.red, // KFC থিম ম্যাচ করার জন্য লাল কালার
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetTodaySales,
          )
        ],
      ),
      body: _currentTab == 0 ? _buildInventoryTab() : _buildReportTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        selectedItemColor: Colors.red,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Menu & Stock"),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: "Sales Report"),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    // সিলেক্টেড ক্যাটাগরি অনুযায়ী আইটেম ফিল্টার করার লজিক
    final filteredItems = _selectedCategory == "ALL"
        ? _items
        : _items.where((item) => item.category == _selectedCategory).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SummaryCard(title: "TODAY'S SALE", value: "৳ ${_calculateTodaySales()}", color: Colors.green),
              const SizedBox(width: 10),
              SummaryCard(title: "LOW STOCK", value: "${_items.where((i) => i.stock < 15).length}", color: Colors.red),
            ],
          ),
        ),

        // ক্যাটাগরি সিলেক্টর হরাইজন্টাল লিস্ট (Horizontal Chips)
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                  selected: isSelected,
                  selectedColor: Colors.red,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // ফিল্টার করা আইটেম লিস্ট
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(child: Text("No items found in this category"))
              : ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.restaurant, color: Colors.white),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Price: ৳${item.sellingPrice} | Stock: ${item.stock}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () => _showActionDialog(item),
                    child: const Text("SELL", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportTab() {
    return _sales.isEmpty
        ? const Center(child: Text("No Sales History Today"))
        : ListView.builder(
      itemCount: _sales.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.green),
        title: Text("${_sales[index].itemName} (x${_sales[index].quantity})"),
        subtitle: Text("Time: ${_sales[index].date.toString().substring(11, 16)}"),
        trailing: Text("৳${_sales[index].totalAmount}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
    );
  }
}