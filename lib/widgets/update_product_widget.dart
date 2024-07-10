import 'package:flutter/material.dart';

class UpdateProductDialog extends StatefulWidget {
  final String itemId;
  final String initialItemName;
  final int initialItemPrice;
  final String initialCategory;
  final String initialDescription;
  final Function(String, int, String, String) onUpdate;

  const UpdateProductDialog({
    Key? key,
    required this.itemId,
    required this.initialItemName,
    required this.initialItemPrice,
    required this.initialCategory,
    required this.initialDescription,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateProductDialogState createState() => _UpdateProductDialogState();
}

class _UpdateProductDialogState extends State<UpdateProductDialog> {
  late TextEditingController _itemNameController;
  late TextEditingController _itemPriceController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialItemName);
    _itemPriceController = TextEditingController(text: widget.initialItemPrice.toString());
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _itemPriceController,
              decoration: const InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: ['Table', 'Chair', 'Sofa', 'Bed', 'Closet', 'Electronic']
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.onUpdate(
              _itemNameController.text,
              int.tryParse(_itemPriceController.text) ?? 0,
              _selectedCategory,
              _descriptionController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
