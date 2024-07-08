import 'dart:async';
import 'package:flutter/material.dart';

class AdsSection extends StatefulWidget {
  final List<String> ads;
  final PageController pageController;

  const AdsSection({
    Key? key,
    required this.ads,
    required this.pageController,
  }) : super(key: key);

  @override
  _AdsSectionState createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  int _currentAdIndex = 0;
  late Timer _adTimer;

  @override
  void initState() {
    super.initState();
    _startAdTimer();
  }

  @override
  void dispose() {
    _adTimer.cancel();
    super.dispose();
  }

  void _startAdTimer() {
    _adTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentAdIndex = (_currentAdIndex + 1) % widget.ads.length;
      });
      widget.pageController.animateToPage(
        _currentAdIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.ads.length,
            controller: widget.pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentAdIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                widget.ads[index],
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
                widget.ads.length,
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
    );
  }
}
