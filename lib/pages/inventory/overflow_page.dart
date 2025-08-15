import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OverflowPage extends StatefulWidget {
  const OverflowPage({super.key});

  @override
  State<OverflowPage> createState() => _OverflowPageState();
}

class _OverflowPageState extends State<OverflowPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up_outlined,
            size: 64,
            color: AppTheme.successGreen,
          ),
          const SizedBox(height: 16),
          Text(
            '报溢管理',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '报溢管理功能正在开发中...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}