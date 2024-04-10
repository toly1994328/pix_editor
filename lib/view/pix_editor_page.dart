import 'package:flutter/material.dart';

import '../data/pix_cell.dart';
import '../data/pix_editor_config.dart';
import 'pix_editor_painter.dart';

class PixEditorPage extends StatefulWidget {
  const PixEditorPage({super.key});

  @override
  State<PixEditorPage> createState() => _PixEditorPageState();
}

class _PixEditorPageState extends State<PixEditorPage> {
  List<PixCell> pixCells = [];

  PixEditorConfig config = PixEditorConfig(
    column: 5,
    row: 5,
    name: "Fx",
    backgroundColor: const Color(0xfff0f0f0),
    gridColor: Colors.white,
    showGrid: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: LayoutBuilder(
            builder: (ctx, cts) => GestureDetector(
              onTapDown: (detail) => _handleTapDown(
                  detail, Size(cts.maxWidth, cts.maxWidth), config),
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: PixEditorPainter(config: config, pixCells: pixCells),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(
      TapDownDetails details, Size size, PixEditorConfig config) {
    double stepH = size.height / config.row;
    double stepW = size.height / config.row;
    int x = details.localPosition.dx ~/ stepW;
    int y = details.localPosition.dy ~/ stepH;
    bool hasPix = pixCells.where((e) => e.position == (x, y)).isNotEmpty;
    if (hasPix) {
      pixCells.removeWhere((e) => e.position == (x, y));
    } else {
      pixCells.add(PixCell(color: const Color(0xff5fc6f5), position: (x, y)));
    }
    pixCells = List.of(pixCells);
    setState(() {});
  }
}
