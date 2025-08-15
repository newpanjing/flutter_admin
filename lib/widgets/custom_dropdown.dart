import 'package:flutter/material.dart';

/// 全局下拉框管理器 - 确保只有一个下拉框可以打开
class _DropdownManager {
  static _CustomDropdownState? _currentOpenDropdown;
  
  static void openDropdown(_CustomDropdownState dropdown) {
    // 关闭当前打开的下拉框
    if (_currentOpenDropdown != null && _currentOpenDropdown != dropdown) {
      _currentOpenDropdown!._closeDropdown();
    }
    _currentOpenDropdown = dropdown;
  }
  
  static void closeDropdown(_CustomDropdownState dropdown) {
    if (_currentOpenDropdown == dropdown) {
      _currentOpenDropdown = null;
    }
  }
}

/// 自定义下拉框组件 - Web风格设计
class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final double? width;
  final String? label;
  final IconData? prefixIcon;

  const CustomDropdown({
    Key? key,
    this.value,
    required this.items,
    required this.itemBuilder,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.width,
    this.label,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    // 通知全局管理器
    _DropdownManager.openDropdown(this);
    
    _isOpen = true;
    _animationController.forward();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {}); // 更新图标状态
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _isOpen = false;
      _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      
      // 通知全局管理器
      _DropdownManager.closeDropdown(this);
      setState(() {}); // 更新图标状态
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 全屏透明区域，用于检测外部点击
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // 下拉框内容
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: widget.width ?? size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: _animation.value,
                        child: Opacity(
                          opacity: _animation.value,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 200,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                width: 1,
                              ),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: widget.items.length,
                                itemBuilder: (context, index) {
                                  final item = widget.items[index];
                                  final isSelected = item == widget.value;
                                  
                                  return InkWell(
                                    onTap: () {
                                      widget.onChanged?.call(item);
                                      _closeDropdown();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                                            : Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.itemBuilder(item),
                                              style: TextStyle(
                                                color: isSelected
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFF333333),
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check,
                                              color: Color(0xFF4CAF50),
                                              size: 16,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 主要的下拉框容器
        Container(
          margin: widget.label != null 
              ? const EdgeInsets.only(top: 8) 
              : EdgeInsets.zero,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              key: _key,
              onTap: _toggleDropdown,
              child: Container(
                width: widget.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? Colors.white
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isOpen
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(
                        widget.prefixIcon,
                        color: const Color(0xFF666666),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        widget.value != null
                            ? widget.itemBuilder(widget.value as T)
                            : widget.hint ?? '请选择',
                        style: TextStyle(
                          color: widget.value != null
                              ? const Color(0xFF333333)
                              : const Color(0xFF999999),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.enabled
                            ? (_isOpen ? const Color(0xFF4CAF50) : const Color(0xFF666666))
                            : const Color(0xFF999999),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 浮动标签
        if (widget.label != null)
          Positioned(
            left: 12,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white,
              child: Text(
                widget.label!,
                style: TextStyle(
                  color: _isOpen 
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}