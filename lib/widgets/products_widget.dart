import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/pages/product_detail_page.dart';

Future<DocumentSnapshot> getUserData(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}

class ProductsSection extends StatelessWidget {
  final Stream<List<DocumentSnapshot>> productStream;

  const ProductsSection({
    Key? key,
    required this.productStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: StreamBuilder<List<DocumentSnapshot>>(
        stream: productStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          List<DocumentSnapshot> products = snapshot.data!;
          String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

          List<DocumentSnapshot> filteredProducts = products.where((product) => product.get('userId') != currentUserID).toList();

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              DocumentSnapshot product = filteredProducts[index];
              String itemId = product.id;
              String itemName = product.get('itemName') ?? '';
              int itemPrice = product.get('itemPrice') ?? 0;
              String category = product.get('category') ?? 'Other';
              String itemDescription = product.get('itemDescription') ?? '';
              String userId = product.get('userId') ?? '';
              IconData iconData;

              switch (category.toLowerCase()) {
                case 'table':
                  iconData = Icons.table_restaurant_outlined;
                  break;
                case 'chair':
                  iconData = Icons.chair_alt_outlined;
                  break;
                case 'sofa':
                  iconData = Icons.weekend_outlined;
                  break;
                case 'bed':
                  iconData = Icons.king_bed_outlined;
                  break;
                case 'closet':
                  iconData = Icons.storage_outlined;
                  break;
                case 'electronic':
                  iconData = Icons.devices_other_outlined;
                  break;
                default:
                  iconData = Icons.category;
              }

              return FutureBuilder<DocumentSnapshot>(
                future: getUserData(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!userSnapshot.hasData) {
                    return const Center(child: Text('User not found'));
                  }

                  String userName = userSnapshot.data!.get('name') ?? 'Unknown';
                  String phoneNum = userSnapshot.data!.get('phoneNum') ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            itemId: itemId,
                            itemName: itemName,
                            itemPrice: itemPrice,
                            category: category,
                            userId: userId,
                            userName: userName,
                            phoneNum: phoneNum,
                            description: itemDescription,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color(0xffFFFFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 45.0),
                            child: Icon(iconData, size: 80.0, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              itemName,
                              style: const TextStyle(fontSize: 18, color: Color(0xff1A1A1A), fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Owner: $userName',
                              style: const TextStyle(fontSize: 12, color: Color(0xff1A1A1A), fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Rp.$itemPrice',
                              style: const TextStyle(color: Color(0xffFF9F2D), fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}