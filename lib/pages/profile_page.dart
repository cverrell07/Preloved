import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preloved/pages/add_product_page.dart';
import 'package:preloved/pages/login_page.dart';
import 'package:preloved/pages/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'My',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffFF9F2D)),
              ),
              TextSpan(
                text: ' Profile',
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
        currentIndex: 2,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
