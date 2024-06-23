import 'dart:ui';

class PixEditorConfig {
  final int row; // 行
  final int column; // 列
  final String name; // 名称
  final Color backgroundColor; // 背景色
  final Color gridColor; // 网格颜色
  final bool showGrid; // 网格颜色

  PixEditorConfig({
    required this.row,
    required this.showGrid,
    required this.column,
    required this.backgroundColor,
    required this.name,
    required this.gridColor,
  });

  // static double boxSize = 15;

  // Size get size => Size(row * boxSize, column * boxSize);

  PixEditorConfig copyWith({
    int? row,
    int? column,
    String? name,
    Color? backgroundColor,
    Color? gridColor,
    bool? showGrid,
  }) =>
      PixEditorConfig(
        row: row ?? this.row,
        showGrid: showGrid ?? this.showGrid,
        column: column ?? this.column,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        name: name ?? this.name,
        gridColor: gridColor ?? this.gridColor,
      );
}
