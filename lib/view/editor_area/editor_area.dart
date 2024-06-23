import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pix_editor/data/pix_editor_config.dart';

import '../../bloc/pix_paint_logic.dart';
import '../../bloc/project_config_logic.dart';
import '../pix_editor_painter.dart';

class EditorArea extends StatelessWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectConfigLogic configLogic = ProjectConfigScope.read(context);
    PixPaintLogic paintLogic = PixPaintScope.read(context);

    void onScale(PointerSignalEvent event) {
      if (event is PointerScrollEvent) {
        if (event.scrollDelta.dy < 0) {
          paintLogic.setScale(1.1, origin: event.localPosition);
        } else {
          paintLogic.setScale(0.9, origin: event.localPosition);
        }
      }
    }

    void onMove(DragUpdateDetails details) {
      paintLogic.translation(details.delta.dx, details.delta.dy);
    }

    void onTapDown(TapDownDetails details) {
      paintLogic.handleTap(details.localPosition);
    }

    void onSecondaryTapDown(TapDownDetails details) {
      paintLogic.handleTap(details.localPosition, action: PixAction.delete);
    }

    return Listener(
      onPointerSignal: onScale,
      child: GestureDetector(
        onPanUpdate: onMove,
        onTapDown: onTapDown,
        onSecondaryTapDown: onSecondaryTapDown,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: PixEditorPainter(
              projectConfigLogic: configLogic,
              pixPaintLogic: paintLogic,
            ),
            child: const Center(),
          ),
        ),
      ),
    );
  }
}
