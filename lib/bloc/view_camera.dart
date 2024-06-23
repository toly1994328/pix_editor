// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-22
// Contact Me:  1981462002@qq.com

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

mixin ViewCamera on ChangeNotifier {
  Size _viewSize = Size.zero;
  Size _playSize = Size.zero;
  final Matrix4 _transformer = Matrix4.identity();

  Size get viewSize => _viewSize;
  Size get playSize => _playSize;
  Matrix4 get transformer => _transformer;

  double _pixSide = 0;

  double get pixSide => _pixSide;

  (int, int) get gridSize;

  double fitPadding = 20;

  @protected
  void onViewBoxChanged(Size old, Size size) {}

  set viewSize(Size size) {
    if (size == _viewSize) return;
    Size oldSize = _viewSize;
    _viewSize = size;
    _updatePlaySize(size);
    centerContent(size, _playSize);
    scheduleMicrotask(() {
      onViewBoxChanged(oldSize, size);
    });
  }

  void changeGridSize() {
    _updatePlaySize(_viewSize);
    centerContent(_viewSize, _playSize);
  }

  void _updatePlaySize(Size viewSize) {
    double padding = fitPadding * 2;
    int row = gridSize.$1;
    int column = gridSize.$2;
    if (row > column) {
      _pixSide = (viewSize.width - padding) / row;
    } else {
      _pixSide = (viewSize.height - padding) / column;
    }
    _playSize = Size(gridSize.$1 * _pixSide, gridSize.$2 * _pixSide);
  }

  double get scale => _transformer.getMaxScaleOnAxis();

  void setScale(double value, {Offset origin = Offset.zero}) {
    double dx = _transformer.getTranslation().x;
    double dy = _transformer.getTranslation().y;
    Offset center = (origin - Offset(dx, dy)) / scale;

    Matrix4 scaleM = Matrix4.diagonal3Values(value, value, 0);
    Matrix4 moveM = Matrix4.translationValues(center.dx, center.dy, 0);
    Matrix4 backM = Matrix4.translationValues(-center.dx, -center.dy, 0);
    _transformer.multiply(moveM);
    _transformer.multiply(scaleM);
    _transformer.multiply(backM);
    notifyListeners();
  }

  void centerContent(Size viewBox, Size pixSize) {
    _transformer.setIdentity();
    double dx = (viewBox.width - pixSize.width) / 2;
    double dy = (viewBox.height - pixSize.height) / 2;
    _transformer.translate(dx, dy);
  }

  void translation(double dx, double dy) {
    Matrix4 moveM = Matrix4.translationValues(dx / scale, dy / scale, 0);
    _transformer.multiply(moveM);
    notifyListeners();
  }

  Offset transformOffset(Offset src) {
    double dx = _transformer.getTranslation().x;
    double dy = _transformer.getTranslation().y;
    return (src - Offset(dx, dy)) / scale;
  }

  (int x, int y) transformPoint(Offset src) {
    Offset offset = transformOffset(src);
    return (offset.dx ~/ pixSide, offset.dy ~/ pixSide);
  }
}
