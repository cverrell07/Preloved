import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              String itemName = products[index].get('itemName') ?? '';
              int itemPrice = products[index].get('itemPrice') ?? 0;
              String category = products[index].get('category') ?? 'Other';
              IconData iconData;

              switch (category.toLowerCase()) {
                case 'table':
                  iconData = Icons.table_chart_outlined;
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

              return Card(
                color: const Color(0xffFFFFFF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: Icon(iconData, size: 80.0, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Rp.$itemPrice',
                        style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text(
                        itemName,
                        style: const TextStyle(fontSize: 16, color: Color(0xff1A1A1A), fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.favorite_border,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
