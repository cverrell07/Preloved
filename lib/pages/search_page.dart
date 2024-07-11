import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/services/search_service.dart';
import 'package:preloved/pages/product_detail_page.dart';

Future<DocumentSnapshot> getUserData(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  StreamSubscription? _searchListener;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_search);
    _fetchAllProducts();
  }

  @override
  void dispose() {
    _searchListener?.cancel();
    _searchController.removeListener(_search);
    _searchController.dispose();
    super.dispose();
  }

  void _fetchAllProducts() async {
    final products = await FirebaseFirestore.instance.collection('products').get();
    if (mounted) {
      setState(() {
        _searchResults = products.docs;
      });
    }
  }

  void _search() async {
    if (_searchController.text.isEmpty) {
      _fetchAllProducts();
      return;
    }

    final results = await SearchService().searchProducts(_searchController.text);
    if (mounted) {
      setState(() {
        _searchResults = results;
      });
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'table':
        return Icons.table_restaurant_outlined;
      case 'chair':
        return Icons.chair_alt_outlined;
      case 'sofa':
        return Icons.weekend_outlined;
      case 'bed':
        return Icons.king_bed_outlined;
      case 'closet':
        return Icons.storage_outlined;
      case 'electronic':
        return Icons.devices_other_outlined;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _searchResults.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                String itemId = _searchResults[index].id;
                String itemName = _searchResults[index].get('itemName') ?? '';
                int itemPrice = _searchResults[index].get('itemPrice') ?? 0;
                String category = _searchResults[index].get('category') ?? 'Other';
                String itemDescription = _searchResults[index].get('itemDescription') ?? '';
                String userId = _searchResults[index].get('userId') ?? '';
                IconData iconData = getCategoryIcon(category);

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
            ),
    );
  }
}
