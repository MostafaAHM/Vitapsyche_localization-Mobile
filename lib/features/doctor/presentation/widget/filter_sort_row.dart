// widgets/filter_sort_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';

class FilterSortRow extends StatelessWidget {
  final VoidCallback onFilterPressed;

  const FilterSortRow({super.key, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton(),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return SizedBox(
      width: 150.w,
      child: ElevatedButton.icon(
        onPressed: onFilterPressed,
        label: Text('Filter',
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        icon: Icon(
          Icons.filter_list_outlined,
          color: Colors.white,
          size: 28.sp,
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding:const EdgeInsets.symmetric(vertical: 10).w,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15).w)),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25).w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: DropdownButton<String>(
          value: 'Sort by',
          icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
          items: _buildSortItems(),
          onChanged: (String? newValue) {},
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildSortItems() {
    return ['Sort by', 'Name', 'Experience', 'Rating'].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: const TextStyle(color: Colors.black)),
      );
    }).toList();
  }
}
