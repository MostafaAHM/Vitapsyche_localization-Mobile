import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_details_screen.dart'; // Import the new screen

class CategoryServicesScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends State<CategoryServicesScreen> {
  List<dynamic> services = [];
  List<dynamic> filteredServices = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      return;
    }

    try {
      // Fetch all categories
      final categoriesResponse = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/categories/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Categories Status Code: ${categoriesResponse.statusCode}');
      print('Categories Response Body: ${categoriesResponse.body}');

      if (categoriesResponse.statusCode == 200) {
        final List<dynamic> categories = json.decode(categoriesResponse.body);

        // Find the selected category by ID
        final selectedCategory = categories.firstWhere(
          (category) => category['id'] == widget.categoryId,
          orElse: () => null,
        );

        if (selectedCategory == null) {
          print('Category not found.');
          setState(() {
            isLoading = false;
          });
          return;
        }

        final List<int> serviceIds =
            List<int>.from(selectedCategory['service_ids'] ?? []);

        // Fetch details for each service in parallel
        List<Future<dynamic>> serviceFutures =
            serviceIds.map((serviceId) async {
          final serviceResponse = await http.get(
            Uri.parse(
                'https://abdokh.pythonanywhere.com/api/services/$serviceId/'),
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          );

          if (serviceResponse.statusCode == 200) {
            return json.decode(serviceResponse.body);
          } else {
            print(
                'Failed to load service $serviceId. Status Code: ${serviceResponse.statusCode}');
            return null;
          }
        }).toList();

        // Wait for all service futures to complete
        List<dynamic> serviceDetails = await Future.wait(serviceFutures);

        // Filter out any null values (failed requests)
        serviceDetails =
            serviceDetails.where((service) => service != null).toList();

        setState(() {
          services = serviceDetails;
          filteredServices = serviceDetails;
          isLoading = false;
        });
      } else {
        print(
            'Failed to load categories. Status Code: ${categoriesResponse.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterServices(String query) {
    setState(() {
      filteredServices = services.where((service) {
        final name = service['name'].toString().toLowerCase();
        final price = service['price'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            price.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or price...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
              ),
              onChanged: _filterServices,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredServices.isEmpty
              ? const Center(
                  child: Text('No services available for this category.'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(
                              serviceId: service['id'],
                            ),
                          ),
                        );
                      },
                      child: ServiceCard(
                        imageUrl: service['image'],
                        name: service['name'],
                        price: service['price'],
                      ),
                    );
                  },
                ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;

  const ServiceCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service Image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
          ),
          // Service Name and Price
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: $price',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
