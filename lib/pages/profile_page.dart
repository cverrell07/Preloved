import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/pages/add_product_page.dart';
import 'package:preloved/pages/home_page.dart';
import 'package:preloved/pages/login_page.dart';
import 'package:preloved/pages/product_detail_page.dart';

Future<DocumentSnapshot> getUserData(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'My',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Color(0xff1A1A1A)),
              ),
              TextSpan(
                text: ' Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xffFF9F2D)),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 2,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
              break;
            case 2:
              break;
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: getUserData(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData) {
                  return const Center(child: Text('User not found'));
                }

                String userName =
                    userSnapshot.data!.get('name') ?? 'Unknown';
                String phoneNum = userSnapshot.data!.get('phoneNum') ?? '';
                String email = userSnapshot.data!.get('email') ?? '';
                String initials = userName.isNotEmpty ? userName[0] : '?';

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xffFF9F2D),
                        radius: 50,
                        child: Text(
                          initials,
                          style: const TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A1A1A)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        phoneNum,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff1A1A1A)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        email,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff1A1A1A)),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  List<DocumentSnapshot> products = snapshot.data!.docs;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot product = products[index];
                      String itemId = product.id;
                      String itemName = product.get('itemName') ?? '';
                      int itemPrice = product.get('itemPrice') ?? 0;
                      String category = product.get('category') ?? 'Other';
                      String itemDescription =
                          product.get('itemDescription') ?? '';
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

                      Future<DocumentSnapshot> productOwnerFuture =
                          getUserData(userId);

                      return FutureBuilder<DocumentSnapshot>(
                        future: productOwnerFuture,
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!userSnapshot.hasData) {
                            return const Center(child: Text('User not found'));
                          }

                          String productOwnerName =
                              userSnapshot.data!.get('name') ?? 'Unknown';
                          String productOwnerPhoneNum =
                              userSnapshot.data!.get('phoneNum') ?? '';

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
                                    userName: productOwnerName,
                                    phoneNum: productOwnerPhoneNum,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 45.0),
                                    child: Icon(iconData,
                                        size: 80.0,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      itemName,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff1A1A1A),
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      'Owner: $productOwnerName',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff1A1A1A),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      'Rp.$itemPrice',
                                      style: const TextStyle(
                                          color: Color(0xffFF9F2D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
            ),
          ],
        ),
      ),
    );
  }
}
