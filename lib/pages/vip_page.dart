import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _selectedPlan = 1; // 默认选择月度套餐
  
  final List<Map<String, dynamic>> _vipPlans = [
    {
      'id': 0,
      'title': '体验版',
      'subtitle': '7天免费试用',
      'price': '0',
      'originalPrice': '99',
      'duration': '7天',
      'features': [
        '基础功能使用',
        '数据导出限制',
        '客服支持',
        '基础报表',
      ],
      'color': Colors.grey,
      'popular': false,
    },
    {
      'id': 1,
      'title': 'VIP月度',
      'subtitle': '最受欢迎',
      'price': '99',
      'originalPrice': '199',
      'duration': '月',
      'features': [
        '全功能无限制使用',
        '无限数据导出',
        '优先客服支持',
        '高级数据分析',
        '自定义报表',
        '数据备份',
      ],
      'color': Colors.green,
      'popular': true,
    },
    {
      'id': 2,
      'title': 'VIP年度',
      'subtitle': '超值优惠',
      'price': '999',
      'originalPrice': '1188',
      'duration': '年',
      'features': [
        '全功能无限制使用',
        '无限数据导出',
        '专属客服支持',
        '高级数据分析',
        '自定义报表',
        '数据备份',
        'API接口调用',
        '多用户协作',
      ],
      'color': Colors.orange,
      'popular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 顶部导航栏
                _buildTopBar(),
                
                // 主要内容
                Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      // 标题区域
                      _buildHeader(),
                      
                      const SizedBox(height: 60),
                      
                      // 套餐选择
                      _buildPricingCards(),
                      
                      const SizedBox(height: 60),
                      
                      // 功能对比表
                      _buildFeatureComparison(),
                      
                      const SizedBox(height: 60),
                      
                      // 常见问题
                      _buildFAQ(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTopBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.green.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.diamond,
                color: Colors.green,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'ERP VIP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // 返回按钮
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            label: const Text(
              '返回系统',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '解锁全部功能',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          '升级VIP，享受更强大的企业管理功能',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[400],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // 特色功能展示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureBadge(Icons.analytics, '高级分析'),
            const SizedBox(width: 24),
            _buildFeatureBadge(Icons.cloud_sync, '云端同步'),
            const SizedBox(width: 24),
            _buildFeatureBadge(Icons.support_agent, '专属客服'),
            const SizedBox(width: 24),
            _buildFeatureBadge(Icons.security, '数据安全'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPricingCards() {
    return Row(
      children: _vipPlans.map((plan) {
        final isSelected = plan['id'] == _selectedPlan;
        final isPopular = plan['popular'] as bool;
        
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlan = plan['id'];
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey[700]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ] : null,
                    ),
                    child: Column(
                      children: [
                        // 套餐标题
                        Text(
                          plan['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          plan['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 价格
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '¥',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              plan['price'],
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Text(
                              '/${plan['duration']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        
                        if (plan['originalPrice'] != plan['price']) ...[
                          const SizedBox(height: 8),
                          Text(
                            '原价 ¥${plan['originalPrice']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        // 功能列表
                        ...((plan['features'] as List<String>).map((feature) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                        
                        const SizedBox(height: 32),
                        
                        // 选择按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showPaymentDialog(plan);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.green : Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isSelected ? '立即购买' : '选择套餐',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 热门标签
                  if (isPopular)
                    Positioned(
                      top: -8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '最受欢迎',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildFeatureComparison() {
    final features = [
      {'name': '基础功能', 'free': true, 'vip': true},
      {'name': '数据导出', 'free': false, 'vip': true},
      {'name': '高级报表', 'free': false, 'vip': true},
      {'name': '数据备份', 'free': false, 'vip': true},
      {'name': 'API接口', 'free': false, 'vip': true},
      {'name': '多用户协作', 'free': false, 'vip': true},
      {'name': '专属客服', 'free': false, 'vip': true},
    ];
    
    return Column(
      children: [
        Text(
          '功能对比',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 32),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Table(
            children: [
              // 表头
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                children: [
                  _buildTableCell('功能', isHeader: true),
                  _buildTableCell('免费版', isHeader: true),
                  _buildTableCell('VIP版', isHeader: true),
                ],
              ),
              
              // 功能行
              ...features.map((feature) {
                return TableRow(
                  children: [
                    _buildTableCell(feature['name'] as String),
                    _buildTableCell(
                      feature['free'] as bool ? '✓' : '✗',
                      isCheck: true,
                      isAvailable: feature['free'] as bool,
                    ),
                    _buildTableCell(
                      feature['vip'] as bool ? '✓' : '✗',
                      isCheck: true,
                      isAvailable: feature['vip'] as bool,
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isCheck = false,
    bool isAvailable = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader
              ? Colors.white
              : isCheck
                  ? (isAvailable ? Colors.green : Colors.red)
                  : Colors.grey[300],
        ),
      ),
    );
  }
  
  Widget _buildFAQ() {
    final faqs = [
      {
        'question': '如何取消订阅？',
        'answer': '您可以随时在账户设置中取消订阅，取消后将在当前计费周期结束时停止续费。',
      },
      {
        'question': '支持哪些支付方式？',
        'answer': '我们支持支付宝、微信支付、银行卡等多种支付方式。',
      },
      {
        'question': '数据安全如何保障？',
        'answer': '我们采用银行级别的数据加密技术，确保您的数据安全。同时提供定期备份服务。',
      },
      {
        'question': '是否提供发票？',
        'answer': '是的，我们为所有付费用户提供正规发票，可在付款后申请开具。',
      },
    ];
    
    return Column(
      children: [
        Text(
          '常见问题',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 32),
        
        ...faqs.map((faq) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['question']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  faq['answer']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  void _showPaymentDialog(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.payment,
                color: Colors.green,
                size: 48,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                '确认购买',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                '${plan['title']} - ¥${plan['price']}/${plan['duration']}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _processPayment(plan);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('确认支付'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _processPayment(Map<String, dynamic> plan) {
    // 模拟支付处理
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.green,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                '正在处理支付...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    // 模拟支付延迟
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // 关闭加载对话框
      
      // 显示支付成功
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  '支付成功！',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'VIP权益已激活',
                  style: TextStyle(
                    color: Colors.grey[300],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop(); // 返回主界面
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('返回系统'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}