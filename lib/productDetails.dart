import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  final Color oliveColor = const Color(0xFF2196F3); 
  final Color goldColor = const Color.fromARGB(255, 0, 0, 0); 

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Center(
          child: Text(
            product['name'] ?? 'Product Details',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF2196F3),
        iconTheme: IconThemeData(color: goldColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product['image'] ?? '',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    product['name'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: oliveColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        product['description'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.price_check, color: goldColor),
                      const SizedBox(width: 6),
                      Text(
                        '\$${product['price']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: oliveColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Quantity selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                      icon: Icon(Icons.remove_circle, color: goldColor),
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: oliveColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: Icon(Icons.add_circle, color: goldColor),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _addToCart(product),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: oliveColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cartItems');

    List<dynamic> cartList = cartJson != null ? jsonDecode(cartJson) : [];

    double price = product['price'] * 1.0;
    int qty = quantity;
    double total = price * qty;

    Map<String, dynamic> cartItem = {
      'name': product['name'],
      'image': product['image'],
      'price': price,
      'quantity': qty,
      'totalPrice': total,
    };

    cartList.add(cartItem);

    await prefs.setString('cartItems', jsonEncode(cartList));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart successfully!'),
      duration: Duration(seconds: 1),
      ),
    );
  }
}
