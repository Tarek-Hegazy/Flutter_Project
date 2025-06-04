import 'package:flutter/material.dart';
import 'package:flutter_application_1/productDetails.dart';
import 'product.dart';
import 'package:google_fonts/google_fonts.dart';
class Allproducts extends StatefulWidget {

  _AllProductsState createState()=> _AllProductsState();
}

class _AllProductsState extends State<Allproducts> {
    bool _isLoading = true;
  final List<Map<String,dynamic>> productData  = [
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
      "image": "https://image.made-in-china.com/2f0j00QHybdVzjYauf/GS500-GPS-LED-Flashlight-Health-Monitoring-Fitness-Tracking-Notifications-Voice-Assistans-Wearable-Technology-Men-Man-1-43inch-Smartwatch.jpg",
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
    setState(() {
      _isLoading = false;
    });
  }

  //open product details
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
          builder: (context) => ProductDetailsPage(product: {
            'id': matchedProduct.id,
            'name': matchedProduct.name,
            'category': matchedProduct.category,
            'description': matchedProduct.description,
            'price': matchedProduct.price,
            'discount': matchedProduct.discount,
            'image': matchedProduct.image,
          }),
        ),
      );
    } else {
      print("Product not found");
    }
  }
  //open product details

    @override
@override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Shop',
                  style: GoogleFonts.cairo(fontSize: 28,fontWeight: FontWeight.bold,color: Color(0xFF2196F3),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.88,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
              ),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(allProducts[index]);
              },
            ),
          ],
        ),
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