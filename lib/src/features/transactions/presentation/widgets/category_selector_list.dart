import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/transactions/domain/category_item.dart';
import 'package:flutter/material.dart';

class CategorySelectorList extends StatelessWidget {
  final List<CategoryItem> categories;
  final CategoryItem selectedCategory;
  final ValueChanged<CategoryItem> onCategorySelected;

  const CategorySelectorList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Category",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text('See all', style: TextStyle(color: AppColors.primary)),
          ],
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory.id == cat.id;
              return _CategoryItemWidget(
                category: cat,
                isSelected: isSelected,
                onTap: () => onCategorySelected(cat),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 8);
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class _CategoryItemWidget extends StatelessWidget {
  final CategoryItem category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItemWidget({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 4)
                  : null,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: category.color,
              child: Icon(category.icon, color: AppColors.background),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
