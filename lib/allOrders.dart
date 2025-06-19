import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({Key? key}) : super(key: key);

  @override
  State<AllOrdersPage> createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  List<dynamic> allOrders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersJson = prefs.getString('allOrders');
    if (ordersJson != null) {
      setState(() {
        allOrders = jsonDecode(ordersJson);
      });
    }
  }

  double calculateOrderTotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) => sum + (item['totalPrice'] ?? 0.0));
  }

  final Color backgroundColor = Color(0xFFFEF7FF);
  final Color primaryTextColor = Color(0xFF2196F3); 
  final Color secondaryTextColor = Color(0xFFFFFFF); 
  final Color accentTextColor = Color.fromARGB(255, 0, 0, 0);
  final Color priceColor = Color.fromARGB(255, 0, 0, 0); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'All Orders',
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
        ),
      ),
      body: allOrders.isEmpty
          ? Center(
              child: Text(
                'No orders found 📭',
                style: TextStyle(color: primaryTextColor, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                final order = allOrders[index];
                final items = order['items'] as List<dynamic>;
                final total = calculateOrderTotal(items);

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${index + 1}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8),

                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order['name'] ?? '',
                                style: TextStyle(
                                  color: accentTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              'Address: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order['address'] ?? '',
                                style: TextStyle(
                                  color: accentTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              'Phone: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order['phone'] ?? '',
                                style: TextStyle(
                                  color: accentTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              'Date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order['date']?.toString().substring(0, 16) ??
                                    '',
                                style: TextStyle(
                                  color: accentTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          height: 24,
                          thickness: 1,
                          color: primaryTextColor.withOpacity(0.3),
                        ),

                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      Text(
                                        'Qty: ${item['quantity']}',
                                        style: TextStyle(
                                          color: primaryTextColor.withOpacity(
                                            0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item['totalPrice'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: priceColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Divider(color: primaryTextColor.withOpacity(0.3)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            'Order Total: ',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryTextColor,
                            ),),
                            
                            Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: priceColor,
                            ),),

                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
