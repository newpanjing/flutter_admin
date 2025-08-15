import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import 'finance/income_expense_page.dart';
import 'finance/invoice_management_page.dart';
import 'finance/report_analysis_page.dart';

class FinanceManagementPage extends StatefulWidget {
  const FinanceManagementPage({super.key});

  @override
  State<FinanceManagementPage> createState() => _FinanceManagementPageState();
}

class _FinanceManagementPageState extends State<FinanceManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<FinanceModule> _modules = [
    FinanceModule(
      title: '收支管理',
      icon: Icons.account_balance_wallet,
      description: '管理收入和支出记录',
      color: AppTheme.successGreen,
    ),
    FinanceModule(
      title: '发票管理',
      icon: Icons.receipt_long,
      description: '管理销售、采购和费用发票',
      color: AppTheme.primaryBlue,
    ),
    FinanceModule(
      title: '报表分析',
      icon: Icons.analytics,
      description: '财务数据分析和可视化报表',
      color: AppTheme.warningYellow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _modules.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题和描述
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '财务管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理企业财务收支、发票和报表分析',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              // 快捷统计卡片
              Row(
                children: [
                  _buildQuickStatCard('本月收入', '¥285,600', Icons.trending_up, AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildQuickStatCard('本月支出', '¥156,800', Icons.trending_down, Colors.red),
                  const SizedBox(width: 16),
                  _buildQuickStatCard('净利润', '¥128,800', Icons.account_balance, AppTheme.primaryBlue),
                ],
              ),
            ],
          ),
        ),
        
        // 模块导航标签
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            tabs: _modules.map((module) {
              final index = _modules.indexOf(module);
              final isSelected = index == _selectedIndex;
              return Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        module.icon,
                        size: 20,
                        color: isSelected ? module.color : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        module.title,
                        style: TextStyle(
                          color: isSelected ? module.color : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            indicator: BoxDecoration(
              color: _modules[_selectedIndex].color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 24),
        
        // 模块内容
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              IncomeExpensePage(),
              InvoiceManagementPage(),
              ReportAnalysisPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 财务模块数据模型
class FinanceModule {
  final String title;
  final IconData icon;
  final String description;
  final Color color;

  FinanceModule({
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
  });
}