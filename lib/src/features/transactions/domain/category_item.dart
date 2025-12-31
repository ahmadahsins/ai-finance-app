import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:flutter/material.dart';

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

final List<CategoryItem> kCategories = [
  // EXPENSE CATEGORIES
  CategoryItem(
    id: '1',
    name: 'Food',
    icon: Icons.restaurant,
    color: const Color(0xFFFFA000),
    type: TransactionType.expense,
  ),
  CategoryItem(
    id: '2',
    name: 'Transport',
    icon: Icons.directions_bus,
    color: const Color(0xFF42A5F5),
    type: TransactionType.expense,
  ),
  CategoryItem(
    id: '3',
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: const Color(0xFFEF5350),
    type: TransactionType.expense,
  ),
  CategoryItem(
    id: '4',
    name: 'Games',
    icon: Icons.gamepad,
    color: const Color(0xFF26A69A),
    type: TransactionType.expense,
  ),

  // INCOME CATEGORIES
  CategoryItem(
    id: '5',
    name: 'Salary',
    icon: Icons.payments,
    color: const Color(0xFF66BB6A),
    type: TransactionType.income,
  ),
  CategoryItem(
    id: '6',
    name: 'Bonus',
    icon: Icons.card_giftcard,
    color: const Color(0xFFAB47BC),
    type: TransactionType.income,
  ),
];
