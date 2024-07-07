import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
  int _currentAdIndex = 0;
  Timer? _adTimer;
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
    'Desk',
    'Electronic',
  ];

  final List<String> _recommendations = [
    'OMO Bean Bag Sofa',
    'Daisie Black Chair',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _pageController = PageController(viewportFraction: 1);
    _startAdTimer();
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAdTimer() {
    _adTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentAdIndex = (_currentAdIndex + 1) % _ads.length;
      });
      _pageController.animateToPage(
        _currentAdIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Hi, ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Color(0xff1a1a1a)), // Gaya font untuk "Hi,"
              ),
              TextSpan(
                text: _userName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffFF9F2D)), // Gaya font untuk username
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Tambahkan aksi pencarian di sini
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Tambahkan aksi keranjang belanja di sini
            },
          ),
        ],
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200.0,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: _ads.length,
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentAdIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        _ads[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _ads.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentAdIndex
                                ? const Color(0xff1A1A1A)
                                : const Color.fromARGB(255, 214, 214, 214),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Shop by Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Tambahkan aksi view all di sini
                    },
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
            Container(
              height: 80.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  switch (_categories[index].toLowerCase()) {
                    case 'table':
                      iconData = Icons.table_chart;
                      break;
                    case 'chair':
                      iconData = Icons.chair;
                      break;
                    case 'sofa':
                      iconData = Icons.weekend;
                      break;
                    case 'bed':
                      iconData = Icons.bed;
                      break;
                    case 'desk':
                      iconData = Icons.work;
                      break;
                    case 'electronic':
                      iconData = Icons.devices_other;
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
                            _categories[index],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20.0),
            // Recommendations for User
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'You might Love it!',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Tambahkan aksi view all di sini
                    },
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _recommendations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xffFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/product${index + 1}.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '\$${(index + 1) * 50}.00',
                            style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: Text(
                            _recommendations[index],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
