
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/pix_paint_logic.dart';
import '../bloc/project_config_logic.dart';
import 'bottom_bar/bottom_bar.dart';
import 'editor_area/editor_area.dart';
import 'menu_bar/app_menu_bar.dart';
import 'menu_bar/menu_tool_bar.dart';
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

  //读取 assets 中的图片
  Future<img.Image?> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return img.decodeImage(Uint8List.fromList(bytes));
  }

  @override
  void initState() {
    super.initState();

    // loadImageFromAssets('assets/images/Item_02.png').then((value) {
    //   if (value == null) return;
    //   List<PixCell> cells = [];
    //   projectConfigLogic.updateColumn(value.width);
    //   projectConfigLogic.updateRow(value.height);
    //   print(value.width);
    //   for (int x = 0; x < value.width; x++) {
    //     for (int y = 0; y < value.height; y++) {
    //       var pixel = value.getPixel(y, x);
    //       var color = Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(),
    //           pixel.g.toInt(), pixel.b.toInt());
    //       if (color != Colors.transparent) {
    //         cells.add(PixCell(color: color, position: (y, x)));
    //       }
    //     }
    //   }
    //   pixPaintLogic.setPixCells(cells);
    //
    //   // setState(() {
    //   //   image = value;
    //   // });
    // });
  }

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
          AppMenuBar(),
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
