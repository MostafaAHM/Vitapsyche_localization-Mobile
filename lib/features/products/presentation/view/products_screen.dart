import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/products/data/product_model.dart';
import 'package:flutter_mindmed_project/features/products/data/req_json_products.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/main.dart';
import 'package:provider/provider.dart';
import '../../data/cart_item_data.dart';
import '../cubit/cart_cubit.dart';
import '../widget/massge_done.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _dataProducts = [];

  Future<void> _fetchProdcts(BuildContext context) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final jsonPath = isArabic 
        ? 'assets/json/products_ar.json' 
        : 'assets/json/products.json';

    try {
      List<dynamic> jsonData = await ReqJsonProducts.readJsonData(path: jsonPath);
      setState(() {
        _dataProducts = jsonData.map((e) => Product.fromJson(e)).toList();
        _filteredProducts = List.from(_dataProducts);
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProdcts(context);
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_dataProducts);
      });
    } else {
      setState(() {
        _filteredProducts = _dataProducts
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  OutlineInputBorder _textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide.none,
    );
  }

  Widget _search(BuildContext context) {
    final localizations = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _filterProducts,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          filled: true,
          fillColor: grayColor.withAlpha(50),
          hintText: localizations.searchHere,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          border: _textFieldBorder(),
          enabledBorder: _textFieldBorder(),
          focusedBorder: _textFieldBorder(),
        ),
      ),
    );
  }

  Widget _productCard(Product product, BuildContext context) {
    final localizations = S.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.detailsProduct,
          arguments: {
            'title': product.title,
            'price': product.price,
            'image': product.images,
            'about': product.about
          },
        );
      },
      child: Card(
        color: secoundryColor,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: 85,
                width: 85,
                child: Image.asset(product.images.first.url),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: mainBlueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price} ${localizations.egpCurrency}',
                          style: const TextStyle(
                            color: mainBlueColor,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          tooltip: localizations.addToCart,
                          onPressed: () {
                            addToCart(
                              product.title,
                              product.price,
                              product.images,
                              product.about
                            );
                            massgeSuccessfully(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(String title, double price, List<ImageData> imagePath, List<String> about) {
    final cartCubit = context.read<CartCubit>();
    final priceValue = price;

    cartCubit.addToCart(
      CartItemData(
        about: about,
        image: imagePath,
        title: title,
        seller: '@someSeller',
        value: priceValue,
        count: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    
    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: AppBar(
        foregroundColor: primaryColor,
        backgroundColor: secoundryColor,
        centerTitle: true,
        title: Text(
          localizations.products,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.cartScreen);
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          _search(context),
          Expanded(
            child: _filteredProducts.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _productCard(product, context);
                    },
                  )
                : Center(
                    child: Text(
                      localizations.noProductsFound,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}