import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/pages/home_page.dart';
import 'package:preloved/pages/profile_page.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = '';
  int _itemPrice = 0;
  String _itemDescription = '';
  String _selectedCategory = 'Table';

  final List<String> _categories = [
    'Table',
    'Chair',
    'Sofa',
    'Bed',
    'Closet',
    'Electronic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Preloved',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffFF9F2D)),
              ),
              TextSpan(
                text: ' a Product',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Color(0xff1A1A1A)),
              ),
            ],
          ),
        ),
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
        currentIndex: 1,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
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
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  onSaved: (value) {
                    _itemName = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _itemPrice = int.tryParse(value ?? '0') ?? 0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Description'),
                  maxLines: 3,
                  onSaved: (value) {
                    _itemDescription = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      try {
                        await FirebaseFirestore.instance.collection('products').add({
                          'itemName': _itemName,
                          'itemPrice': _itemPrice,
                          'itemDescription': _itemDescription,
                          'category': _selectedCategory,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'createdAt': FieldValue.serverTimestamp(), // Timestamp saat produk dibuat
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added successfully')),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        print('Error adding product: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add product')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 20),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor: const Color(0xffFFD4A1),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
