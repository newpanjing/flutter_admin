import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 现代化对话框组件 - 符合Web设计和人体工学原则
class ModernDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final double? maxHeight;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsets? contentPadding;
  final IconData? titleIcon;
  final Color? titleIconColor;

  const ModernDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.maxHeight,
    this.showCloseButton = true,
    this.onClose,
    this.contentPadding,
    this.titleIcon,
    this.titleIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: width ?? 600,
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            _buildTitleBar(context),
            
            // 内容区域
            Flexible(
              child: Container(
                width: double.infinity,
                padding: contentPadding ?? const EdgeInsets.fromLTRB(32, 0, 32, 24),
                child: content,
              ),
            ),
            
            // 操作按钮区域
            if (actions != null && actions!.isNotEmpty)
              _buildActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 24, 24, 24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 标题图标
          if (titleIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (titleIconColor ?? AppTheme.successGreen).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                titleIcon,
                color: titleIconColor ?? AppTheme.successGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          // 标题文本
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
          
          // 关闭按钮
          if (showCloseButton)
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onClose ?? () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!.map((action) {
          final index = actions!.indexOf(action);
          return Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? 12 : 0,
            ),
            child: action,
          );
        }).toList(),
      ),
    );
  }
}

/// 现代化表单字段组件
class ModernFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  final EdgeInsets? contentPadding;

  const ModernFormField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标签
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        
        // 输入框
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          onTap: onTap,
          readOnly: readOnly,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textSecondary,
                    size: 20,
                  )
                : null,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: prefixIcon != null ? 12 : 16,
                  vertical: maxLines > 1 ? 16 : 14,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.successGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFF44336),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFF44336),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8F9FA),
          ),
        ),
      ],
    );
  }
}

/// 现代化按钮组件
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool loading;
  final double? width;
  final EdgeInsets? padding;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.loading = false,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppTheme.successGreen;
        textColor = Colors.white;
        borderColor = AppTheme.successGreen;
        break;
      case ButtonType.secondary:
        backgroundColor = Colors.white;
        textColor = AppColors.textPrimary;
        borderColor = const Color(0xFFE0E0E0);
        break;
      case ButtonType.danger:
        backgroundColor = const Color(0xFFF44336);
        textColor = Colors.white;
        borderColor = const Color(0xFFF44336);
        break;
    }

    return SizedBox(
      width: width,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: textColor,
                    size: 16,
                  ),
                if ((loading || icon != null) && text.isNotEmpty)
                  const SizedBox(width: 8),
                if (text.isNotEmpty)
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ButtonType {
  primary,
  secondary,
  danger,
}

/// 现代化下拉选择组件
class ModernDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final IconData? prefixIcon;
  final bool enabled;
  final String? Function(T?)? validator;

  const ModernDropdown({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    required this.itemBuilder,
    this.onChanged,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标签
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        
        // 下拉框
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    itemBuilder(item),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.successGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFF44336),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFF44336),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8F9FA),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}