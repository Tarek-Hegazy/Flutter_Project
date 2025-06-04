import 'product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/productDetails.dart';
import 'allProducts.dart';
import 'package:google_fonts/google_fonts.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String storeName = "Smart Box";
  String? loggedUserFirstName;
  bool _isLoading = true;
  List<Product> featuredProducts = [];
List<Map<String, String>> categories = [
    {'name': 'Computers', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgz99wNm8nvLQICJwwZXbViOxZaQYts0wbNQ&s'},
    {'name': 'Mobiles', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyS3heFCuKzqCP49-eUiPkPtfGMjHv62LOSA&s'},
    {'name': 'Audio', 'image': 'https://m.media-amazon.com/images/I/61kFsU+CYkL.jpg'},
    {'name': 'Accessories', 'image': 'https://m.media-amazon.com/images/I/91ZoAo8tCvL.__AC_SX300_SY300_QL70_ML2_.jpg'},
    {'name': 'Tablets', 'image': 'https://abedtahan.com/cdn/shop/files/IPAD-10_256GB_SILVER.jpg?v=1726819355'},
    {'name': 'TVs', 'image': 'https://www.sony-africa.com/image/18737a4b0b2a1405e6a18cd00e582bfc?fmt=pjpeg&wid=1200&hei=470&bgcolor=F1F5F9&bgc=F1F5F9'},
    {'name': 'Cameras', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyW7l-lLoY4nBYEnqA9ydYbUU56CgDtaq-rQ&s'},
    {'name': 'Wearables', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeVWmrJZ1Q8LNG7vhC2JH2w5s1xjwwEb_5BtG9fj3Xn_gaViSX6M-imhi2LPqtwucDiJk&usqp=CAU'},
  ];


    final List<Map<String, dynamic>> productData = [
    {
      "id": 1,
      "name": "Laptop Pro",
      "category": "Computers",
      "description":
          "A powerful laptop with a high-performance processor and long battery life.",
      "price": 2500,
      "discount": 15,
      "image":
          "https://i5.walmartimages.com/seo/Restored-Apple-MacBook-Pro-Laptop-13-Retina-Display-Touch-Bar-Intel-Core-i5-16GB-RAM-512GB-SSD-Mac-OSx-Catalina-Space-Gray-MLH12LL-A-Refurbished_8d770d2d-c4b7-4883-9daa-677661f07fcb.707fc395e032c29b06d02561d220156a.jpeg",
    },
    {
      "id": 2,
      "name": "Smartphone Ultra",
      "category": "Mobiles",
      "description":
          "A flagship smartphone with an amazing camera and fast charging.",
      "price": 1200,
      "discount": 10,
      "image":
          "https://ennap.com/cdn/shop/files/01_E3_TitaniumViolet_Lockup_1600x1200_d6a6ab64-dbf9-430a-a627-969400f99fc4.jpg?v=1705602276",
    },
    {
      "id": 3,
      "name": "Wireless Headphones",
      "category": "Audio",
      "description":
          "Noise-canceling wireless headphones with 30 hours of battery life.",
      "price": 300,
      "discount": 5,
      "image":
          "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQTR3?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1687660671097",
    },
    {
      "id": 4,
      "name": "Gaming Mouse",
      "category": "Accessories",
      "description":
          "High-precision gaming mouse with RGB lighting and extra buttons.",
      "price": 80,
      "discount": 20,
      "image": "https://m.media-amazon.com/images/I/71fEUcsDDEL.jpg",
    },
    {
      "id": 5,
      "name": "Tablet Max",
      "category": "Tablets",
      "description": "A tablet perfect for work and play, with stylus support.",
      "price": 900,
      "discount": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwyLLMoVsJ_7YRPNrThu1D43ajBTUXU66E1A&s",
    },
    {
      "id": 6,
      "name": "4K Smart TV",
      "category": "TVs",
      "description": "Large 4K smart TV with HDR and streaming apps built-in.",
      "price": 1500,
      "discount": 18,
      "image":
          "https://api-rayashop.freetls.fastly.net/media/catalog/product/cache/4e49ac3a70c0b98a165f3fa6633ffee1/g/u/gu43-du7179-uxzg-007-r-perspective2-black_i2th4jjfhimyezo1.jpg",
    },
    {
      "id": 7,
      "name": "Bluetooth Speaker",
      "category": "Audio",
      "description": "Portable speaker with deep bass and waterproof design.",
      "price": 150,
      "discount": 8,
      "image":
          "https://ae01.alicdn.com/kf/S2fda3ad012754647be6e06cf82911632V.jpg",
    },
    {
      "id": 8,
      "name": "DSLR Camera",
      "category": "Cameras",
      "description": "Professional DSLR camera for high-quality photography.",
      "price": 1800,
      "discount": 22,
      "image":
          "https://media.gettyimages.com/id/185278433/photo/black-digital-slr-camera-in-a-white-background.jpg?s=612x612&w=gi&k=20&c=0L7vA3lq5Xy30FwCIBRAsW7Ud1i12z36vzPZ16pdeL4=",
    },
    {
      "id": 9,
      "name": "Smartwatch Gen 5",
      "category": "Wearables",
      "description":
          "Smartwatch with fitness tracking, GPS, and notifications.",
      "price": 400,
      "discount": 10,
      "image":
          "https://image.made-in-china.com/2f0j00QHybdVzjYauf/GS500-GPS-LED-Flashlight-Health-Monitoring-Fitness-Tracking-Notifications-Voice-Assistans-Wearable-Technology-Men-Man-1-43inch-Smartwatch.jpg",
    },
    {
      "id": 10,
      "name": "External Hard Drive",
      "category": "Accessories",
      "description": "2TB external hard drive for backup and file storage.",
      "price": 120,
      "discount": 15,
      "image": "https://i.ebayimg.com/images/g/hdkAAOSwyGpmjOdM/s-l400.jpg",
    },
  ];

  late List<Product> allProducts;


  @override
  void initState() {
    super.initState();
    allProducts = productData.map((item) => Product.fromJson(item)).toList();
    _loadInitialData();
    _isLoading = false;
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('first_name') ?? 'User';
    setState(() {
      loggedUserFirstName = firstName;
    });
  }


Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse(
      'https://ib.jamalmoallart.com/api/v1/products/category/$category',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for $category');
    }
  }


  // open product Detalis
  void navigateToProductDetails(
    BuildContext context,
    String productName,
    List<Product> allProducts,
  ) {
    final matchedProduct = allProducts.firstWhere(
      (product) => product.name == productName,
      orElse: () => Product(
        id: 0,
        name: '',
        category: '',
        description: '',
        price: 0,
        discount: 0,
        image: '',
      ),
    );

    if (matchedProduct.name != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            product: {
              'id': matchedProduct.id,
              'name': matchedProduct.name,
              'category': matchedProduct.category,
              'description': matchedProduct.description,
              'price': matchedProduct.price,
              'discount': matchedProduct.discount,
              'image': matchedProduct.image,
            },
          ),
        ),
      );
    } else {
      print("Product not found");
    }
  }
  // open product Detalis



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Center(child: Text(
                      'Welcome, $loggedUserFirstName!',
                      style: GoogleFonts.cairo(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFF2196F3)),
                    ),),
                  _showTopProducts(),
                  _buildFeaturedProductsSlider(),
                  _showCategories(),
                  _buildNewArrivalsSection(),
                ],
              ),
            ),
    );
  }

Widget _showTopProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.star, color: Color(0xFF1976D2)),
              SizedBox(width: 8),
              Text(
                'Top Rated Products',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: allProducts.length.clamp(0, 5),
            controller: PageController(viewportFraction: 0.8),
            padEnds: false,
            itemBuilder: (context, index) {
              final product = allProducts[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFFB8C7FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // النصوص
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${product.price.toStringAsFixed(2)} USD',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Rate: 5.0 ⭐',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // الصورة
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white70,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              color: Colors.white, 
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 12),
      ],
    );
  }


  Widget _buildFeaturedProductsSlider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.featured_play_list, color: Color(0xFF1976D2)), 
                SizedBox(width: 8),
                Text(
                  'Featured Products',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 30,
              mainAxisSpacing: 20,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildProductCard(allProducts[index]);
            },
          ),
        ],
      ),
    );
  }

Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () => navigateToProductDetails(context, product.name, allProducts),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14,horizontal: 8), 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric( horizontal: 
                20,
              ), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget _showCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.category, color: Color(0xFF1976D2)), 
              SizedBox(width: 8),
              Text(
                'All Categories',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    final categoryName = category['name']!;
                    final filteredProducts = allProducts
                        .where((product) => product.category == categoryName)
                        .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(
                          category: categoryName,
                          products: filteredProducts,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image: NetworkImage(category['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(category['name']!, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xFF2196F3))),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }



  Widget _buildNewArrivalsSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.new_releases, color: Color(0xFF1976D2)), 
                SizedBox(width: 8),
                Text(
                  'New Arrivals',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, 
                    letterSpacing: 1.0, 
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: allProducts.length > 4
                ? 4
                : allProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(allProducts[index]);
            },
          ),
        ],
      ),
    );
  }



}



class CategoryProductsPage extends StatefulWidget {
  final String category;
  final List<Product> products;

  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  void navigateToProductDetails(
    BuildContext context,
    String productName,
    List<Product> allProducts,
  ) {
    final matchedProduct = allProducts.firstWhere(
      (product) => product.name == productName,
      orElse: () => Product(
        id: 0,
        name: '',
        category: '',
        description: '',
        price: 0,
        discount: 0,
        image: '',
      ),
    );

    if (matchedProduct.name != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            product: {
              'id': matchedProduct.id,
              'name': matchedProduct.name,
              'category': matchedProduct.category,
              'description': matchedProduct.description,
              'price': matchedProduct.price,
              'discount': matchedProduct.discount,
              'image': matchedProduct.image,
            },
          ),
        ),
      );
    } else {
      print("Product not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Products',style: GoogleFonts.cairo(fontSize: 18,color: Color(0xFF2196F3),fontWeight: FontWeight.bold),)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: widget.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return _buildProductCard(widget.products[index]);
          },
        ),
      ),
    );
  }

Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () =>
          navigateToProductDetails(context, product.name, widget.products),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6), 
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8), 
          ],
        ),
      ),
    );
  }



}
