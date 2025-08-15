import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/chart_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 页面标题
          Text(
            '仪表板',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '欢迎使用ERP管理系统，这里是您的业务概览',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // 统计卡片行
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: '总销售额',
                  value: '¥1,234,567',
                  subtitle: '本月',
                  icon: Icons.trending_up,
                  color: AppTheme.successGreen,
                  trend: '+12.5%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: '订单数量',
                  value: '2,468',
                  subtitle: '本月',
                  icon: Icons.shopping_cart_outlined,
                  color: AppTheme.primaryBlue,
                  trend: '+8.2%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: '客户数量',
                  value: '1,856',
                  subtitle: '总计',
                  icon: Icons.people_outline,
                  color: AppTheme.warningYellow,
                  trend: '+5.1%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: '库存价值',
                  value: '¥856,432',
                  subtitle: '当前',
                  icon: Icons.inventory_2_outlined,
                  color: AppTheme.infoBlue,
                  trend: '-2.3%',
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // 图表区域
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 销售趋势图
              Expanded(
                flex: 2,
                child: ChartCard(
                  title: '销售趋势',
                  subtitle: '最近12个月',
                  child: SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 50000,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.borderColor,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('1月', style: style);
                                    break;
                                  case 2:
                                    text = const Text('3月', style: style);
                                    break;
                                  case 4:
                                    text = const Text('5月', style: style);
                                    break;
                                  case 6:
                                    text = const Text('7月', style: style);
                                    break;
                                  case 8:
                                    text = const Text('9月', style: style);
                                    break;
                                  case 10:
                                    text = const Text('11月', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: text,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 50000,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '${(value / 1000).toInt()}K',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                );
                              },
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 11,
                        minY: 0,
                        maxY: 200000,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 80000),
                              const FlSpot(1, 95000),
                              const FlSpot(2, 120000),
                              const FlSpot(3, 110000),
                              const FlSpot(4, 140000),
                              const FlSpot(5, 135000),
                              const FlSpot(6, 160000),
                              const FlSpot(7, 155000),
                              const FlSpot(8, 180000),
                              const FlSpot(9, 175000),
                              const FlSpot(10, 190000),
                              const FlSpot(11, 185000),
                            ],
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryBlue,
                                AppTheme.lightBlue,
                              ],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryBlue.withOpacity(0.3),
                                  AppTheme.lightBlue.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // 产品分类饼图
              Expanded(
                child: ChartCard(
                  title: '产品分类',
                  subtitle: '销售占比',
                  child: SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            // 处理触摸事件
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: AppTheme.primaryBlue,
                            value: 35,
                            title: '35%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppTheme.successGreen,
                            value: 25,
                            title: '25%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppTheme.warningYellow,
                            value: 20,
                            title: '20%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppTheme.errorRed,
                            value: 20,
                            title: '20%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // 最近活动和快速操作
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 最近活动
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.history,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '最近活动',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildActivityItem(
                          '新增客户',
                          '张三 - 北京科技有限公司',
                          '2分钟前',
                          Icons.person_add,
                          AppTheme.successGreen,
                        ),
                        _buildActivityItem(
                          '订单完成',
                          '订单号: #12345 - ¥15,680',
                          '15分钟前',
                          Icons.check_circle,
                          AppTheme.primaryBlue,
                        ),
                        _buildActivityItem(
                          '库存预警',
                          '产品A库存不足，剩余10件',
                          '1小时前',
                          Icons.warning,
                          AppTheme.warningYellow,
                        ),
                        _buildActivityItem(
                          '财务记录',
                          '收款 ¥25,000 - 客户付款',
                          '2小时前',
                          Icons.account_balance_wallet,
                          AppTheme.successGreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // 快速操作
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '快速操作',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.5,
                          children: [
                            _buildQuickAction(
                              '新增客户',
                              Icons.person_add,
                              AppTheme.primaryBlue,
                              () {},
                            ),
                            _buildQuickAction(
                              '创建订单',
                              Icons.add_shopping_cart,
                              AppTheme.successGreen,
                              () {},
                            ),
                            _buildQuickAction(
                              '入库操作',
                              Icons.input,
                              AppTheme.warningYellow,
                              () {},
                            ),
                            _buildQuickAction(
                              '财务记录',
                              Icons.account_balance,
                              AppTheme.infoBlue,
                              () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}