import 'package:flutter/material.dart';

import '../bloc/pix_paint_logic.dart';
import '../bloc/project_config_logic.dart';
import '../data/pix_editor_config.dart';

class PixEditorPainter extends CustomPainter {
  final ProjectConfigLogic projectConfigLogic;
  final PixPaintLogic pixPaintLogic;

  PixEditorPainter({
    required this.projectConfigLogic,
    required this.pixPaintLogic,
  }) : super(repaint: Listenable.merge([pixPaintLogic, projectConfigLogic]));

  PixEditorConfig get config => projectConfigLogic.config;

  @override
  void paint(Canvas canvas, Size size) {
    pixPaintLogic.viewSize = size;
    canvas.clipRect(Offset.zero & size);
    canvas.drawColor(const Color(0xff939393), BlendMode.src);
    canvas.save();
    canvas.transform(pixPaintLogic.transformer.storage);
    Paint bgPaint = Paint()..color = config.backgroundColor;
    canvas.drawRect(Offset.zero & pixPaintLogic.playSize, bgPaint);
    canvas.drawPicture(pixPaintLogic.activePixLayer.picture);
    if (config.showGrid) {
      drawGrid(canvas, pixPaintLogic.pixSide, pixPaintLogic.row, pixPaintLogic.column);
    }
    canvas.restore();
  }

  void drawGrid(Canvas canvas, double boxSize, int row, int column) {
    Paint girdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = config.gridColor;
    Path path = Path();
    double width = row * boxSize;
    double height = column * boxSize;
    for (int i = 0; i <= column; i++) {
      path.moveTo(0, boxSize * i);
      path.relativeLineTo(width, 0);
    }
    for (int i = 0; i <= row; i++) {
      path.moveTo(boxSize * i, 0);
      path.relativeLineTo(0, height);
    }
    canvas.drawPath(path, girdPaint);
  }

  @override
  bool shouldRepaint(covariant PixEditorPainter oldDelegate) {
    return false;
  }
}
