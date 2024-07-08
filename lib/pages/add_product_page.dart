import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text('Create New Item'),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();

                      try {
                        // Simpan data produk ke Firestore
                        await FirebaseFirestore.instance.collection('products').add({
                          'itemName': _itemName,
                          'itemPrice': _itemPrice,
                          'itemDescription': _itemDescription,
                          'category': _selectedCategory,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'createdAt': FieldValue.serverTimestamp(), // Timestamp saat produk dibuat
                        });

                        // Tampilkan pesan sukses atau navigasi kembali
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added successfully')),
                        );

                        // Navigate back to the previous screen
                        Navigator.pop(context);
                      } catch (e) {
                        // Handle errors
                        print('Error adding product: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add product')),
                        );
                      }
                    }
                  },
                  child: const Text('Create Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
