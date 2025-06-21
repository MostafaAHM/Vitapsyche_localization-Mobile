import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/features/products/data/product_model.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../widget/custem_button_card.dart';


class DetailsProduct extends StatefulWidget {
  const DetailsProduct({
    super.key,
    required this.title,
    required this.about,
    required this.image,
    required this.price,
  });

  final String title;
  final List<String> about;
  final List<ImageData> image;
  final double price;

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  Timer? _autoPageTimer;
  late List<ImageData> _images;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _images = widget.image;
      });
      _startAutoPageChange();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoPageTimer?.cancel();
    super.dispose();
  }

  void _startAutoPageChange() {
    _autoPageTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_images.isNotEmpty) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _images.length;
        });

        if (mounted) {
          _pageController.animateToPage(
            _currentImageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    final title = widget.title;
    final about = widget.about;
    final price = widget.price;

    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: AppBar(
        foregroundColor: primaryColor,
        backgroundColor: secoundryColor,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cartScreen),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: _images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: mainBlueColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _images[index].url,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildThumbnails(),
                  const SizedBox(height: 16),
                  Text(
                    localizations.aboutThisProduct,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: about.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '- $item',
                          style: const TextStyle(
                            color: grayColor,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '${localizations.price}: ${localizations.egp} ${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      CustomButtonCard(
                        about: about,
                        title: title,
                        price: price,
                        image: _images,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _images.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentImageIndex = entry.key;
              _pageController.animateToPage(
                entry.key,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: _currentImageIndex == entry.key
                    ? Colors.green
                    : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              entry.value.url,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}