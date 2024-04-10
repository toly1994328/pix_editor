import 'package:flutter/material.dart';

import '../data/pix_cell.dart';
import '../data/pix_editor_config.dart';

class PixEditorPainter extends CustomPainter {
  final PixEditorConfig config;
  final List<PixCell> pixCells;

  PixEditorPainter({
    required this.config,
    required this.pixCells,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()..color = config.backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    drawPixCells(canvas,size);

    if (config.showGrid) {
      drawGrid(canvas, size);
    }
  }

  void drawPixCells(Canvas canvas, Size size){
    Paint cellPaint = Paint();
    double stepH = size.height / config.row;
    double stepW = size.height / config.row;
    for (int i = 0; i < pixCells.length; i++) {
      PixCell cell = pixCells[i];
      double top = cell.position.$1 * stepW;
      double left =  cell.position.$2 * stepH;
      Rect rect = Rect.fromLTWH(top , left, stepW, stepH);
      canvas.drawRect(rect.deflate(-0.2), cellPaint..color = cell.color);
    }
  }

  void drawGrid(Canvas canvas, Size size) {
    Paint girdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = config.gridColor;
    Path path = Path();
    double stepH = size.height / config.row;
    for (int i = 0; i <= config.row; i++) {
      path.moveTo(0, stepH * i);
      path.relativeLineTo(size.width, 0);
    }
    double stepW = size.height / config.row;
    for (int i = 0; i <= config.column; i++) {
      path.moveTo(stepW * i, 0);
      path.relativeLineTo(0, size.height);
    }
    canvas.drawPath(path, girdPaint);
  }

  @override
  bool shouldRepaint(covariant PixEditorPainter oldDelegate) {
    return oldDelegate.config != config || oldDelegate.pixCells != pixCells;
  }
}
