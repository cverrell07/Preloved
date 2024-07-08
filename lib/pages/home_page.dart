import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preloved/pages/add_product_page.dart';
import 'package:preloved/pages/profile_page.dart';
import 'package:preloved/widgets/ads_widget.dart';
import 'package:preloved/widgets/categories_widget.dart';
import 'package:preloved/widgets/firebase_service.dart';
import 'package:preloved/widgets/products_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName = 'User';
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  late PageController _pageController;

  final List<String> _ads = [
    'assets/ad1.png',
    'assets/ad2.png',
    'assets/ad3.png',
    'assets/ad4.png'
  ];

  final List<String> _categories = [
    'Table',
    'Chair',
    'Sofa',
    'Bed',
    'Closet',
    'Electronic',
  ];

  Stream<List<DocumentSnapshot>> getProductStream() {
    return FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) => snapshot.docs);
  }

  @override
  void initState() {
    super.initState();
    _loadUserNameFromFirebase();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserNameFromFirebase() async {
    // Example method to fetch username from Firebase using FirebaseService
    try {
      String? userName = await FirebaseService().getUserName(userId!);
      if (userName != null && userName.isNotEmpty) {
        setState(() {
          _userName = userName;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Hi, ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Color(0xff1a1a1a)),
              ),
              TextSpan(
                text: _userName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffFF9F2D)),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              //
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: 0,
          onTap: (int index) {
            switch (index) {
              case 0:
                break;
              case 1:
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                break;
            }
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdsSection(
              ads: _ads,
              pageController: _pageController,
            ),
            CategoriesSection(
              categories: _categories,
            ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You might Love it!',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ProductsSection(
              productStream: getProductStream(),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
