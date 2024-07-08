import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  final List<String> categories;

  const CategoriesSection({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          height: 80.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              IconData iconData;
              // Determine icon based on category (similar to previous implementation)
              switch (categories[index].toLowerCase()) {
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
                  iconData = Icons.bed_outlined;
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
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: 80.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData, size: 30.0),
                      const SizedBox(height: 5.0),
                      Text(
                        categories[index],
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
