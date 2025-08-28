import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/cache_image.dart';

class PlanGallery extends StatefulWidget {
  const PlanGallery({super.key});

  @override
  _PlanGalleryState createState() => _PlanGalleryState();
}

class _PlanGalleryState extends State<PlanGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
    // Add more image URLs here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return CacheImage(
                imageUrl: _images[index],
                errorColor: Colors.grey,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
