import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class ReportAnalysisPage extends StatefulWidget {
  const ReportAnalysisPage({super.key});

  @override
  State<ReportAnalysisPage> createState() => _ReportAnalysisPageState();
}

class _ReportAnalysisPageState extends State<ReportAnalysisPage> {
  String _selectedPeriod = '本月';
  String _selectedReportType = '收支分析';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  
  // 模拟数据
  final List<MonthlyData> _monthlyData = [
    MonthlyData('1月', 120000, 80000),
    MonthlyData('2月', 150000, 95000),
    MonthlyData('3月', 180000, 110000),
    MonthlyData('4月', 160000, 105000),
    MonthlyData('5月', 200000, 120000),
    MonthlyData('6月', 220000, 135000),
    MonthlyData('7月', 190000, 115000),
    MonthlyData('8月', 210000, 125000),
    MonthlyData('9月', 240000, 140000),
    MonthlyData('10月', 260000, 155000),
    MonthlyData('11月', 280000, 170000),
    MonthlyData('12月', 300000, 180000),
  ];

  final List<CategoryData> _categoryData = [
    CategoryData('销售收入', 450000, AppTheme.successGreen),
    CategoryData('服务收入', 280000, AppTheme.primaryBlue),
    CategoryData('其他收入', 120000, AppTheme.warningYellow),
    CategoryData('人员成本', -180000, Colors.red),
    CategoryData('运营费用', -120000, Colors.orange),
    CategoryData('其他支出', -80000, Colors.purple),
  ];

  final List<ProjectData> _projectData = [
    ProjectData('电商平台开发', 350000, 280000, 70000),
    ProjectData('企业管理系统', 280000, 220000, 60000),
    ProjectData('移动应用开发', 180000, 150000, 30000),
    ProjectData('数据分析平台', 220000, 180000, 40000),
    ProjectData('云服务集成', 150000, 120000, 30000),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题和控制
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '报表分析',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '财务数据分析和可视化报表',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // 报表类型选择
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _selectedReportType,
                      decoration: const InputDecoration(
                        labelText: '报表类型',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: ['收支分析', '分类统计', '项目分析', '趋势预测']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedReportType = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 时间周期选择
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value: _selectedPeriod,
                      decoration: const InputDecoration(
                        labelText: '时间周期',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: ['本周', '本月', '本季度', '本年', '自定义']
                          .map((period) => DropdownMenuItem(
                                value: period,
                                child: Text(period),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedPeriod = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 导出按钮
                  ModernButton(
                    text: '导出报表',
                    icon: Icons.download,
                    onPressed: _exportReport,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 统计卡片
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '总收入',
                '¥${_getTotalIncome().toStringAsFixed(2)}',
                Icons.trending_up,
                AppTheme.successGreen,
                '+12.5%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                '总支出',
                '¥${_getTotalExpense().toStringAsFixed(2)}',
                Icons.trending_down,
                Colors.red,
                '+8.3%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                '净利润',
                '¥${(_getTotalIncome() - _getTotalExpense()).toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                AppTheme.primaryBlue,
                '+15.2%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                '利润率',
                '${((_getTotalIncome() - _getTotalExpense()) / _getTotalIncome() * 100).toStringAsFixed(1)}%',
                Icons.percent,
                AppTheme.warningYellow,
                '+2.1%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // 图表区域
        Expanded(
          child: Row(
            children: [
              // 左侧图表
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getChartTitle(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                _buildLegendItem('收入', AppTheme.successGreen),
                                const SizedBox(width: 16),
                                _buildLegendItem('支出', Colors.red),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: _buildMainChart(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // 右侧图表和数据
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // 饼图
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '收支分类',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: _buildPieChart(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 项目排行
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '项目收益排行',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: _buildProjectRanking(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMainChart() {
    switch (_selectedReportType) {
      case '收支分析':
        return _buildLineChart();
      case '分类统计':
        return _buildBarChart();
      case '项目分析':
        return _buildProjectChart();
      case '趋势预测':
        return _buildTrendChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50000,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.borderColor,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
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
                if (value.toInt() < _monthlyData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _monthlyData[value.toInt()].month,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50000,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value / 1000).toInt()}K',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.borderColor),
        ),
        minX: 0,
        maxX: (_monthlyData.length - 1).toDouble(),
        minY: 0,
        maxY: 350000,
        lineBarsData: [
          LineChartBarData(
            spots: _monthlyData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.income);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [AppTheme.successGreen.withOpacity(0.8), AppTheme.successGreen],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.successGreen,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.successGreen.withOpacity(0.3),
                  AppTheme.successGreen.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: _monthlyData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.expense);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.red.withOpacity(0.8), Colors.red],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.3),
                  Colors.red.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 500000,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < _categoryData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _categoryData[value.toInt()].name.length > 4
                          ? '${_categoryData[value.toInt()].name.substring(0, 4)}...'
                          : _categoryData[value.toInt()].name,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value / 1000).toInt()}K',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _categoryData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.amount.abs(),
                color: entry.value.color,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProjectChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 400000,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < _projectData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _projectData[value.toInt()].name.length > 6
                          ? '${_projectData[value.toInt()].name.substring(0, 6)}...'
                          : _projectData[value.toInt()].name,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value / 1000).toInt()}K',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _projectData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.revenue,
                color: AppTheme.successGreen,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: entry.value.cost,
                color: Colors.red,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrendChart() {
    // 预测数据（基于历史数据的简单线性预测）
    final List<FlSpot> historicalSpots = _monthlyData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.income - entry.value.expense);
    }).toList();
    
    final List<FlSpot> predictedSpots = List.generate(6, (index) {
      final baseIndex = _monthlyData.length;
      final lastProfit = _monthlyData.last.income - _monthlyData.last.expense;
      final growth = 0.05; // 5% 增长预测
      return FlSpot(
        (baseIndex + index).toDouble(),
        lastProfit * (1 + growth * (index + 1)),
      );
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20000,
          verticalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.borderColor,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
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
              interval: 2,
              getTitlesWidget: (double value, TitleMeta meta) {
                final months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月', '1月+', '2月+', '3月+', '4月+', '5月+', '6月+'];
                if (value.toInt() < months.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      months[value.toInt()],
                      style: TextStyle(
                        color: value.toInt() >= 12 ? AppTheme.warningYellow : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20000,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value / 1000).toInt()}K',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.borderColor),
        ),
        minX: 0,
        maxX: 17,
        minY: 0,
        maxY: 200000,
        lineBarsData: [
          // 历史数据
          LineChartBarData(
            spots: historicalSpots,
            isCurved: true,
            color: AppTheme.successGreen,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.successGreen,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
          // 预测数据
          LineChartBarData(
            spots: predictedSpots,
            isCurved: true,
            color: AppTheme.warningYellow,
            barWidth: 3,
            isStrokeCapRound: true,
            dashArray: [5, 5],
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.warningYellow,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final List<PieChartSectionData> sections = _categoryData.map((data) {
      final isExpense = data.amount < 0;
      final value = data.amount.abs();
      final total = _categoryData.fold(0.0, (sum, item) => sum + item.amount.abs());
      final percentage = (value / total * 100);
      
      return PieChartSectionData(
        color: data.color,
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 图例
        Column(
          children: _categoryData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: data.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '¥${data.amount.abs().toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProjectRanking() {
    final sortedProjects = List<ProjectData>.from(_projectData)
      ..sort((a, b) => b.profit.compareTo(a.profit));

    return ListView.builder(
      itemCount: sortedProjects.length,
      itemBuilder: (context, index) {
        final project = sortedProjects[index];
        final rank = index + 1;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '利润: ¥${project.profit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 金色
      case 2:
        return const Color(0xFFC0C0C0); // 银色
      case 3:
        return const Color(0xFFCD7F32); // 铜色
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getChartTitle() {
    switch (_selectedReportType) {
      case '收支分析':
        return '月度收支趋势';
      case '分类统计':
        return '收支分类统计';
      case '项目分析':
        return '项目收益对比';
      case '趋势预测':
        return '利润趋势预测';
      default:
        return '财务分析';
    }
  }

  double _getTotalIncome() {
    return _categoryData
        .where((data) => data.amount > 0)
        .fold(0.0, (sum, data) => sum + data.amount);
  }

  double _getTotalExpense() {
    return _categoryData
        .where((data) => data.amount < 0)
        .fold(0.0, (sum, data) => sum + data.amount.abs());
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正在导出${_selectedReportType}报表...'),
        action: SnackBarAction(
          label: '查看',
          onPressed: () {},
        ),
      ),
    );
  }
}

// 数据模型
class MonthlyData {
  final String month;
  final double income;
  final double expense;

  MonthlyData(this.month, this.income, this.expense);
}

class CategoryData {
  final String name;
  final double amount;
  final Color color;

  CategoryData(this.name, this.amount, this.color);
}

class ProjectData {
  final String name;
  final double revenue;
  final double cost;
  final double profit;

  ProjectData(this.name, this.revenue, this.cost, this.profit);
}