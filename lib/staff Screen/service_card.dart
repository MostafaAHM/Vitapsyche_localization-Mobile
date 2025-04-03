import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/staff%20Screen/EditServiceDetailScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceCardScreen extends StatefulWidget {
  final int doctorId;

  const ServiceCardScreen({super.key, required this.doctorId});

  @override
  State<ServiceCardScreen> createState() => _ServiceCardScreenState();
}

class _ServiceCardScreenState extends State<ServiceCardScreen> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('Error: Access token not found in SharedPreferences');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/services/?doctor_id=${widget.doctorId}'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          services = data;
          isLoading = false;
        });
      } else {
        print('Failed to load services. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load services');
      }
    } catch (error) {
      print('Error fetching services: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Services'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : services.isEmpty
              ? const Center(child: Text('No services available.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditServiceDetailScreen(
                              serviceId: service['id'],
                              doctorId: widget.doctorId,
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
