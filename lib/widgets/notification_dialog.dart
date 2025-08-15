import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationDropdown extends StatefulWidget {
  const NotificationDropdown({super.key});

  @override
  State<NotificationDropdown> createState() => _NotificationDropdownState();
}

class _NotificationDropdownState extends State<NotificationDropdown> {
  List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': '系统更新',
      'content': '系统已更新至最新版本 v2.1.0，新增多项功能优化',
      'time': '2024-01-15 10:30',
      'type': 'system',
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'VIP权益到期提醒',
      'content': '您的VIP会员将于3天后到期，请及时续费以继续享受专属服务',
      'time': '2024-01-14 16:45',
      'type': 'vip',
      'isRead': false,
    },
    {
      'id': 3,
      'title': '数据备份完成',
      'content': '系统数据备份已完成，备份文件已保存至云端',
      'time': '2024-01-14 09:15',
      'type': 'backup',
      'isRead': true,
    },
    {
      'id': 4,
      'title': '新用户注册',
      'content': '用户 "张三" 已成功注册并完成实名认证',
      'time': '2024-01-13 14:20',
      'type': 'user',
      'isRead': true,
    },
    {
      'id': 5,
      'title': '安全提醒',
      'content': '检测到异常登录行为，请及时检查账户安全',
      'time': '2024-01-13 11:30',
      'type': 'security',
      'isRead': false,
    },
  ];

  void _markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((n) => n['id'] == id);
    });
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'system':
        return Icons.system_update;
      case 'vip':
        return Icons.diamond;
      case 'backup':
        return Icons.backup;
      case 'user':
        return Icons.person_add;
      case 'security':
        return Icons.security;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'system':
        return Colors.blue;
      case 'vip':
        return const Color(0xFF00C853);
      case 'backup':
        return Colors.orange;
      case 'user':
        return Colors.purple;
      case 'security':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;
    
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        constraints: const BoxConstraints(
          maxHeight: 500,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D), // 深灰色背景，与主题区分
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00C853).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF00C853).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A), // 更深的背景色
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF00C853).withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Color(0xFF00C853),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '通知中心',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: _markAllAsRead,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        '全部已读',
                        style: TextStyle(
                          color: Color(0xFF00C853),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // 通知列表
            Flexible(
              child: notifications.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            color: Colors.grey[600],
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '暂无通知',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey[800],
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final isRead = notification['isRead'];
                        
                        return Container(
                          color: isRead 
                              ? Colors.transparent
                              : const Color(0xFF00C853).withOpacity(0.05),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _getNotificationColor(notification['type'])
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getNotificationIcon(notification['type']),
                                color: _getNotificationColor(notification['type']),
                                size: 18,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: isRead 
                                          ? FontWeight.normal 
                                          : FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!isRead)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF00C853),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  notification['content'],
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification['time'],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                              color: const Color(0xFF1A1A1A),
                              onSelected: (value) {
                                switch (value) {
                                  case 'read':
                                    _markAsRead(notification['id']);
                                    break;
                                  case 'delete':
                                    _deleteNotification(notification['id']);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                if (!isRead)
                                  PopupMenuItem(
                                    value: 'read',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.mark_email_read,
                                          color: Colors.grey[300],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '标记已读',
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '删除',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (!isRead) {
                                _markAsRead(notification['id']);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}