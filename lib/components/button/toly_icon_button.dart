import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';

class TolyIconButton extends StatefulWidget {
  final Widget icon;
  final Size size;
  final VoidCallback onPressed;
  final bool select;

  const TolyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.size,
     this.select=false,
  });

  @override
  State<TolyIconButton> createState() => _TolyIconButtonState();
}

class _TolyIconButtonState extends State<TolyIconButton> {
  bool _hovered = false;

  Color get color {
    if(widget.select) return Color(0xffbfbfbf);
    if (_hovered) {
      return Color(0xffbfbfbf);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
          child: widget.icon,
        ),
      ),
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _hovered = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hovered = false;
    });
  }
}
