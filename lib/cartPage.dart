import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cartItems');
    if (cartJson != null) {
      setState(() {
        cartItems = jsonDecode(cartJson);
      });
    }
  }

  Future<void> saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartItems', jsonEncode(cartItems));
  }

  Future<void> removeItem(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    await saveCartItems();
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.clear();
    });
    await prefs.remove('cartItems');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart cleared successfully 🧹'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }

  double calculateTotal() {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item['totalPrice'] ?? 0.0),
    );
  }


  Future<void> showOrderDialog() async {
    String name = '';
    String address = '';
    String phone = '';

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Color(0xFFFEF7FF),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Enter Your Info',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Name',
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Address',
                    onChanged: (val) => address = val,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => phone = val,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF2196F3)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (name.isEmpty ||
                              address.isEmpty ||
                              phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill in all fields'),
                                backgroundColor: Color(0xFF2196F3),
                              ),
                            );
                            return;
                          }

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          List<dynamic> allOrders = [];
                          String? previousOrders = prefs.getString('allOrders');
                          if (previousOrders != null) {
                            allOrders = jsonDecode(previousOrders);
                          }

                          allOrders.add({
                            'items': cartItems,
                            'name': name,
                            'address': address,
                            'phone': phone,
                            'date': DateTime.now().toString(),
                          });

                          await prefs.setString(
                            'allOrders',
                            jsonEncode(allOrders),
                          );
                          setState(() {
                            cartItems.clear();
                          });
                          await prefs.remove('cartItems');

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order placed successfully ✅'),
                              backgroundColor: Color(0xFF2196F3),
                            ),
                          );
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF2196F3)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }


  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
      cartItems[index]['totalPrice'] =
          cartItems[index]['price'] * cartItems[index]['quantity'];
    });
    saveCartItems();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity']--;
        cartItems[index]['totalPrice'] =
            cartItems[index]['price'] * cartItems[index]['quantity'];
      });
      saveCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF7FF),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Shopping Cart',
            style: GoogleFonts.cairo(color: Color(0xFF2196F3),fontSize: 22,fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFFFEF7FF),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2196F3)),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty 🛒',
                style: TextStyle(color: Color(0xFF2196F3), fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image'] ?? '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2196F3),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        Text(
                                          '${item['price']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF2196F3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              decreaseQuantity(index),
                                          icon: Icon(
                                            Icons.remove,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        Text(
                                          'Qty: ${item['quantity']}',
                                          style: TextStyle(
                                            color: Color(0xFF2196F3),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              increaseQuantity(index),
                                          icon: Icon(
                                            Icons.add,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Total: \$${item['totalPrice'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => removeItem(index),
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.grey.shade300),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          Text(
                            '\$${calculateTotal().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: showOrderDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2196F3),
                              ),
                              child: Text(
                                'Buy Now',
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: clearCart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  236,
                                  236,
                                  236,
                                ),
                              ),
                              child: Text(
                                'Clear Cart',
                                style: GoogleFonts.cairo(
                                  color: Color(0xFF2196F3),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
