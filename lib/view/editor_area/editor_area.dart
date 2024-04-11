import 'package:flutter/material.dart';

import '../../bloc/pix_paint_logic.dart';
import '../../bloc/project_config_logic.dart';
import '../../data/pix_editor_config.dart';
import '../pix_editor_painter.dart';

class EditorArea extends StatelessWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectConfigLogic configLogic = ProjectConfigScope.read(context);
    PixPaintLogic paintLogic = PixPaintScope.read(context);
    return ColoredBox(
      color: const Color(0xff939393),
      child: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: LayoutBuilder(
            builder: (ctx, cts) => GestureDetector(
              onTapDown: (detail) => _handleTapDown(
                detail,
                Size(cts.maxWidth, cts.maxWidth),
                configLogic.config,
                paintLogic,
              ),
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: PixEditorPainter(
                    projectConfigLogic: configLogic,
                    pixPaintLogic: paintLogic,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(
    TapDownDetails details,
    Size size,
    PixEditorConfig config,
    PixPaintLogic logic,
  ) {
    double stepH = size.height / config.row;
    double stepW = size.height / config.column;
    int x = details.localPosition.dx ~/ stepW;
    int y = details.localPosition.dy ~/ stepH;
    logic.hitPix(x, y);
  }
}
