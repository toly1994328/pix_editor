import 'dart:ui';

import '../../bloc/view_camera.dart';
import '../image_layer.dart';
import '../pix_cell.dart';
import '../pix_editor_config.dart';

class PixLayer extends PaintLayer {
  int row;
  int column;
  final List<PixCell> pixCells;

  PixLayer({
    required this.row,
    required this.column,
    required this.pixCells,
    super.name,
    required super.id,
  });

  @override
  void paint(Canvas canvas, ViewCamera camera) {
    double pixSide = camera.pixSide;
    Paint cellPaint = Paint();
    for (int i = 0; i < pixCells.length; i++) {
      PixCell cell = pixCells[i];
      double top = cell.position.$1 * pixSide;
      double left = cell.position.$2 * pixSide;
      Rect rect = Rect.fromLTWH(top, left, pixSide, pixSide);
      canvas.drawRect(rect.deflate(-0.2), cellPaint..color = cell.color);
    }
  }
}
