import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pix_editor/view/pix_editor_painter.dart';

import '../bloc/pix_paint_logic.dart';
import '../bloc/project_config_logic.dart';
import '../data/pix_cell.dart';
import '../data/pix_editor_config.dart';
import 'bottom_bar/bottom_bar.dart';
import 'editor_area/editor_area.dart';
import 'menu_bar/menu_bar.dart';
import 'operation_area/operation_area.dart';
import 'tool_bar/tool_bar.dart';
import 'package:image/image.dart' as img;

class PixEditorScope extends StatefulWidget {
  const PixEditorScope({super.key});

  @override
  State<PixEditorScope> createState() => _PixEditorScopeState();
}

class _PixEditorScopeState extends State<PixEditorScope> {
  final PixPaintLogic pixPaintLogic = PixPaintLogic();

  final ProjectConfigLogic projectConfigLogic = ProjectConfigLogic();

  @override
  Widget build(BuildContext context) {
    return PixPaintScope(
      notifier: pixPaintLogic,
      child: ProjectConfigScope(
        notifier: projectConfigLogic,
        child: const PixEditorPage(),
      ),
    );
  }
}

class PixEditorPage extends StatelessWidget {
  const PixEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          MenuToolBar(),
          Expanded(
              child: Row(
            children: [
              ToolBar(),
              Expanded(
                  child: Column(
                children: [Expanded(child: EditorArea()), BottomBar()],
              )),
              OperationArea()
            ],
          )),
        ],
      ),
    );
  }
}
