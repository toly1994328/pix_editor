import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../bloc/project_config_logic.dart';
import '../../components/picker/color/toly_color_picker/toly_color_picker.dart';

class ProjectSettings extends StatelessWidget {
  const ProjectSettings({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectConfigLogic configLogic = ProjectConfigScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            "项目配置",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              GridSizeSetting(
                configLogic: configLogic,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("显示网格", style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: configLogic.config.showGrid,
                      onChanged: (bool? value) {
                        configLogic.toggleShowGrid();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "背景颜色",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  TolyColorPicker(
                    color: configLogic.config.backgroundColor,
                    onChange: (Color value) {
                      configLogic.updateBackgroundColor(value);
                    },
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "网格颜色",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  TolyColorPicker(
                    color: configLogic.config.gridColor,
                    onChange: (Color value) {
                      configLogic.updateGridColor(value);
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class GridSetting extends StatelessWidget {
  const GridSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GridSizeSetting extends StatelessWidget {
  final ProjectConfigLogic configLogic;

  const GridSizeSetting({super.key, required this.configLogic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "网格数量",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: CupertinoTextField(
          controller: configLogic.rowCtrl,
          onChanged: _onRowChanged,
          style: TextStyle(fontSize: 12),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "x",
            style: TextStyle(fontSize: 12),
          ),
        ),
        Expanded(
            child: CupertinoTextField(
          controller: configLogic.columnCtrl,
          onChanged: _onColumnChanged,
          style: TextStyle(fontSize: 12),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ))
      ],
    );
  }

  void _onRowChanged(String value) {
    int? row = int.tryParse(value);
    if (row != null && row > 0 && row <= 256) {
      configLogic.updateRow(row);
    }
  }

  void _onColumnChanged(String value) {
    int? column = int.tryParse(value);
    if (column != null && column > 0 && column <= 256) {
      configLogic.updateColumn(column);
    }
  }
}
