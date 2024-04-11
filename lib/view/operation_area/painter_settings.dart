import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../bloc/pix_paint_logic.dart';
import '../../bloc/project_config_logic.dart';
import '../../components/picker/color/toly_color_picker/toly_color_picker.dart';

class PainterSettings extends StatelessWidget {
  const PainterSettings({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            "画笔配置",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              PixPainterColor(),
            ],
          ),
        )
      ],
    );
  }
}

class PixPainterColor extends StatelessWidget {
  const PixPainterColor({super.key});

  @override
  Widget build(BuildContext context) {
    PixPaintLogic logic = PixPaintScope.of(context);
    return Row(
      children: [
        Text(
          "画笔颜色",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 8),
        TolyColorPicker(
          color: logic.paintColor,
          onChange: (Color value) {
            logic.paintColor = value;
          },
        )
      ],
    );
  }
}
