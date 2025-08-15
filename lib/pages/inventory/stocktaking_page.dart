import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StocktakingPage extends StatefulWidget {
  const StocktakingPage({super.key});

  @override
  State<StocktakingPage> createState() => _StocktakingPageState();
}

class _StocktakingPageState extends State<StocktakingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_outlined,
            size: 64,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            '盘点管理',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '盘点管理功能正在开发中...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}