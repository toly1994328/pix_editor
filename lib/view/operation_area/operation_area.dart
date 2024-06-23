import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../bloc/pix_paint_logic.dart';
import '../../bloc/project_config_logic.dart';
import '../../components/picker/color/toly_color_picker/toly_color_picker.dart';
import 'paint_payer.dart';
import 'painter_settings.dart';
import 'project_settings.dart';

class OperationArea extends StatelessWidget {
  const OperationArea({super.key});

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);
    ProjectConfigLogic configLogic = ProjectConfigScope.of(context);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xfff0f0f0),
        border: Border(left: side),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectSettings(),
          SizedBox(height: 16),
          Divider(),
          PainterSettings(),
          SizedBox(height: 16),
          Divider(),
          Expanded( child: ColoredBox(
              color: Color(0xffe8e8e8),
              child: PainterLayer()))
        ],
      ),
    );
  }
}


