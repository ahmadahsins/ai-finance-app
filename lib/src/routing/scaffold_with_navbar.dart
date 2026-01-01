import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: Container(
        height: 72,
        width: 72,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-transaction');
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavbarIcon(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: navigationShell.currentIndex == 0,
              onTap: () => _goBranch(0),
            ),
            _NavbarIcon(
              icon: Icons.history_rounded,
              label: 'History',
              isSelected: navigationShell.currentIndex == 1,
              onTap: () => _goBranch(1),
            ),
            const SizedBox(width: 48),
            _NavbarIcon(
              icon: Icons.chat_bubble_rounded,
              label: 'Chat',
              isSelected: navigationShell.currentIndex == 2,
              onTap: () => _goBranch(2),
            ),
            _NavbarIcon(
              icon: Icons.person_rounded,
              label: 'Profile',
              isSelected: navigationShell.currentIndex == 3,
              onTap: () => _goBranch(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavbarIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
