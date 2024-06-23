import 'package:flutter/material.dart';

import '../data/pix_editor_config.dart';

class ProjectConfigLogic with ChangeNotifier {
  PixEditorConfig _config = PixEditorConfig(
    column: 32,
    row: 32,
    name: "新建文件",
    backgroundColor: const Color(0xfff0f0f0),
    gridColor: Colors.white,
    showGrid: true,
  );

  PixEditorConfig get config => _config;

  set config(PixEditorConfig config) {
    _config = config;
    notifyListeners();
  }

  void updateBackgroundColor(Color color) {
    config = _config.copyWith(backgroundColor: color);
  }

  void updateGridColor(Color color) {
    config = _config.copyWith(gridColor: color);
  }

  void toggleShowGrid() {
    config = _config.copyWith(showGrid: !_config.showGrid);
  }
}

class ProjectConfigScope extends InheritedNotifier<ProjectConfigLogic> {
  const ProjectConfigScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static ProjectConfigLogic of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProjectConfigScope>()!.notifier!;

  static ProjectConfigLogic read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ProjectConfigScope>()!.notifier!;
}
