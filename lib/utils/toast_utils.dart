import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

/// Toast工具类
/// 提供统一的成功和失败提示样式
class ToastUtils {
  /// 显示成功提示
  /// [message] 提示消息
  /// [duration] 显示时长，默认2秒
  static void showSuccess(String message, {Duration? duration}) {
    showToastWidget(
      _buildToast(
        message: message,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        backgroundColor: Colors.green.withOpacity(0.9),
      ),
      duration: duration ?? const Duration(seconds: 2),
      position: ToastPosition.top,
    );
  }

  /// 显示失败提示
  /// [message] 提示消息
  /// [duration] 显示时长，默认3秒
  static void showError(String message, {Duration? duration}) {
    showToastWidget(
      _buildToast(
        message: message,
        icon: Icons.error,
        iconColor: Colors.red,
        backgroundColor: Colors.red.withOpacity(0.9),
      ),
      duration: duration ?? const Duration(seconds: 3),
      position: ToastPosition.top,
    );
  }

  /// 显示警告提示
  /// [message] 提示消息
  /// [duration] 显示时长，默认2.5秒
  static void showWarning(String message, {Duration? duration}) {
    showToastWidget(
      _buildToast(
        message: message,
        icon: Icons.warning,
        iconColor: Colors.orange,
        backgroundColor: Colors.orange.withOpacity(0.9),
      ),
      duration: duration ?? const Duration(milliseconds: 2500),
      position: ToastPosition.top,
    );
  }

  /// 显示信息提示
  /// [message] 提示消息
  /// [duration] 显示时长，默认2秒
  static void showInfo(String message, {Duration? duration}) {
    showToastWidget(
      _buildToast(
        message: message,
        icon: Icons.info,
        iconColor: Colors.blue,
        backgroundColor: Colors.blue.withOpacity(0.9),
      ),
      duration: duration ?? const Duration(seconds: 2),
      position: ToastPosition.top,
    );
  }

  /// 构建Toast组件
  static Widget _buildToast({
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}