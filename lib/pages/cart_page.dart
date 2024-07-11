import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved/pages/product_detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<List<DocumentSnapshot>> cartStream;

  @override
  void initState() {
    super.initState();
    cartStream = FirebaseFirestore.instance.collection('cart').snapshots().map((snapshot) => snapshot.docs);
  }

  void deleteFromCart(String itemId) {
    FirebaseFirestore.instance.collection('cart').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'My ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Color(0xff1a1a1a)),
              ),
              TextSpan(
                text: 'Cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffFF9F2D)),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot>? cartItems = snapshot.data;

          if (cartItems == null || cartItems.isEmpty) {
            return const Center(child: Text('No items in cart'));
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var item = cartItems[index].data() as Map<String, dynamic>;
              IconData iconData;

              switch (item['category']) {
                case 'Table':
                  iconData = Icons.table_restaurant_outlined;
                  break;
                case 'Chair':
                  iconData = Icons.chair_alt_outlined;
                  break;
                case 'Sofa':
                  iconData = Icons.weekend_outlined;
                  break;
                case 'Bed':
                  iconData = Icons.king_bed_outlined;
                  break;
                case 'Closet':
                  iconData = Icons.storage_outlined;
                  break;
                case 'Electronic':
                  iconData = Icons.devices_other_outlined;
                  break;
                default:
                  iconData = Icons.category;
              }

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Icon(iconData, size: 40, color: Theme.of(context).primaryColor),
                  title: Text(item['itemName']),
                  subtitle: Text('Rp.${item['itemPrice']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteFromCart(cartItems[index].id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          itemId: item['itemId'],
                          itemName: item['itemName'],
                          itemPrice: item['itemPrice'],
                          category: item['category'],
                          userId: item['userId'],
                          userName: item['userName'],
                          phoneNum: item['phoneNum'],
                          description: item['description'],
                        ),
                      ),
                    );
                  },
                ),

              );
            },
          );
        },
      ),
    );
  }
}
