import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/widgets/update_product_widget.dart';

class ProductDetailPage extends StatefulWidget {
  final String itemId;
  final String itemName;
  final int itemPrice;
  final String category;
  final String userId;
  final String userName;
  final String phoneNum;
  final String description;

  const ProductDetailPage({
    Key? key,
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.category,
    required this.userId,
    required this.userName,
    required this.phoneNum,
    required this.description,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _visible = false;
  bool _isOwner = false;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _visible = true;

    getCurrentUserId();
    _isOwner = widget.userId == currentUserId;
  }

  void getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;
    } else {
      currentUserId = '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> deleteProduct() async {
    if (_isOwner) {
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.itemId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error deleting product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not authorized to delete this product')),
      );
    }
  }

  Future<void> updateProductDetails({
    required String updatedItemName,
    required int updatedItemPrice,
    required String updatedCategory,
    required String updatedDescription,
  }) async {
    if (_isOwner) {
      try {
        await FirebaseFirestore.instance.collection('products').doc(widget.itemId).update({
          'itemName': updatedItemName,
          'itemPrice': updatedItemPrice,
          'category': updatedCategory,
          'itemDescription': updatedDescription,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product details updated successfully')),
        );
      } catch (e) {
        print('Error updating product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product details')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not authorized to edit this product')),
      );
    }
  }

  void addToCart() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('cart')
        .where('itemId', isEqualTo: widget.itemId)
        .where('userIdAdded', isEqualTo: currentUserId)
        .limit(1)
        .get();

      if (query.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item is already in the cart')),
        );
      } else {
        await FirebaseFirestore.instance.collection('cart').add({
          'itemId': widget.itemId,
          'itemName': widget.itemName,
          'itemPrice': widget.itemPrice,
          'userIdAdded': currentUserId,
          'category': widget.category,
          'userName': widget.userName,
          'phoneNum': widget.phoneNum,
          'description': widget.description,
          'userId': widget.userId
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added to cart')),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product to cart')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    IconData iconData;

    switch (widget.category.toLowerCase()) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Product Details"),
        actions: [
          if (_isOwner)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => UpdateProductDialog(
                    itemId: widget.itemId,
                    initialItemName: widget.itemName,
                    initialItemPrice: widget.itemPrice,
                    initialCategory: widget.category,
                    initialDescription: widget.description,
                    onUpdate: (updatedItemName, updatedItemPrice, updatedCategory, updatedDescription) {
                      updateProductDetails(
                        updatedItemName: updatedItemName,
                        updatedItemPrice: updatedItemPrice,
                        updatedCategory: updatedCategory,
                        updatedDescription: updatedDescription,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Edit Product',
                style: TextStyle(color: Color(0xffFF9F2D)),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Icon(iconData, size: 100.0, color: Theme.of(context).primaryColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(seconds: 1),
                      child: Text(
                        widget.itemName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 241, 224),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Owner: ${widget.userName}',
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 85, 85, 85)),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            widget.phoneNum,
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 85, 85, 85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 20, color: Color(0xff1A1A1A), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Theme.of(context).canvasColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1a1a1a),
                        ),
                      ),
                      Text(
                        'Rp.${widget.itemPrice}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF9F2D),
                        ),
                      ),
                    ],
                  ),
                  _isOwner
                      ? ElevatedButton(
                          onPressed: deleteProduct,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: const Color.fromARGB(255, 255, 170, 164),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Delete Product', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 74, 11, 11)),),
                        )
                      : ElevatedButton(
                          onPressed: addToCart,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: const Color(0xffFFD4A1),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Add to Cart'),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
