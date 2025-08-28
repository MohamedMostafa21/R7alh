import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Destination',
      'Surrounding LandMarks',
      'Hotel',
      'Restaurant & Cafe',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              final isSelected = selectedCategoryIndex == index;

              return GestureDetector(
                onTap: () => setState(() {
                  selectedCategoryIndex = selectedCategoryIndex == index ? -1 : index;
                }),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    categories[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
