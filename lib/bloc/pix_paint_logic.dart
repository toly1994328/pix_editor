import 'package:flutter/material.dart';

import '../data/pix_cell.dart';

class PixPaintLogic with ChangeNotifier {
  final List<PixCell> _pixCells = [];

  List<PixCell> get pixCells => _pixCells;

  Color get paintColor => _paintColor;

  set paintColor(Color value){
    _paintColor = value;
    notifyListeners();
  }

  Color _paintColor = const Color(0xff5ec8f8);


  void setPixCells(List<PixCell> pixCells){
    _pixCells.clear();
    _pixCells.addAll(pixCells);
    notifyListeners();
  }

  // 添加像素点
  void hitPix(int x,int y) {
    bool hasPix = _pixCells.where((e) => e.position == (x, y)).isNotEmpty;
      if (hasPix) {
      _pixCells.removeWhere((e) => e.position == (x, y));
    } else {
      _pixCells.add(PixCell(color: _paintColor, position: (x,y)));
    }
    notifyListeners();
  }
}


class PixPaintScope extends InheritedNotifier<PixPaintLogic> {
  const PixPaintScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static PixPaintLogic of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PixPaintScope>()!.notifier!;

  static PixPaintLogic read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<PixPaintScope>()!.notifier!;
}

