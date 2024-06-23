import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pix_editor/view/menu_bar/menu/menu_action.dart';
import 'package:platform_adapter/platform_adapter.dart';

import '../../bloc/pix_paint_logic.dart';
import '../../bloc/project_config_logic.dart';
import '../../components/button/toly_icon_button.dart';
import '../../data/layer/pix_layer.dart';
import '../../data/pix_cell.dart';
import 'app_tool_menu_bar.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);

    return DragToMoveWrapper(
      child: Container(
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xfff0f0f0),
          border: Border(bottom: side),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 20,
              height: 20,
            ),
            Expanded(
              child: AppToolMenuBar(
                onTapMenu: (v) => _onTapMenu(context, v),
              ),
            ),
            Spacer(),
            WindowButtons()
          ],
        ),
      ),
    );
  }

  void _onTapMenu(BuildContext context, MenuAction? value) async {
    /// TODO 处理菜单事件、快捷键事件
    if (value == MenuAction.importFile) {
      _handleImportImage(context);
    }
    if (value == MenuAction.outputFilePng) {
      PixPaintLogic paintLogic = PixPaintScope.read(context);
      PixLayer pixLayer = paintLogic.activePixLayer;

      final image = img.Image(
        width: pixLayer.row,
        height: pixLayer.column,
        numChannels: 4,
      );
      for (PixCell pix in pixLayer.pixCells) {
        Color color = pix.color;
        image.setPixelRgba(
          pix.position.$1,
          pix.position.$2,
          color.red,
          color.green,
          color.blue,
          color.alpha,
        );
      }

      final Uint8List byteData = img.encodePng(image);
      // Write the PNG formatted data to a file.

      String? result = await FilePicker.platform.saveFile(type: FileType.image);
      if (result != null) {
        File file = File(result);
        await file.writeAsBytes(byteData);
      }

      // PictureRecorder recorder = PictureRecorder();
      // Canvas canvas = Canvas(recorder);
      // Size boxSize = const Size(32, 24);
      // Paint cellPaint = Paint();
      // // var image = paintLogic.activePixLayer.picture.toImageSync(1024, 1024);
      // Size outSize = Size(400, 400);
      // canvas.scale(outSize.width / 1024);
      // canvas.drawPicture(paintLogic.activePixLayer.picture);

      // double side = min(outSize.width , outSize.height);
      // double stepH = side / paintLogic.column;
      // double stepW = side / paintLogic.row;
      // // canvas.translate((size.width-side)/2, 0);
      //
      // for (int i = 0; i < paintLogic.pixCells.length; i++) {
      //   PixCell cell = paintLogic.pixCells[i];
      //   double top = cell.position.$1 * stepW;
      //   double left = cell.position.$2 * stepH;
      //   Rect rect = Rect.fromLTWH(top, left, stepW, stepH);
      //   canvas.drawRect(rect.deflate(-0.2), cellPaint..color = cell.color);
      // }
      // // paint(canvas, boxSize);
      // canvas.drawRect(Offset.zero & boxSize, Paint()..style = PaintingStyle.stroke);
      // var picture = recorder.endRecording();
      // var image =
      //     await picture.toImage(outSize.width.toInt(), outSize.width.toInt());
      //
      // // 获取字节，存入文件
      // ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    }
  }
}

void _handleImportImage(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    // File file = File(result.files.single.path!);

    // var value = img.decodeImage(await file.readAsBytes());

    // if (value == null) return;
    // List<PixCell> cells = [];
    //

    PixPaintLogic paintLogic = PixPaintScope.read(context);
    paintLogic.setImage(result.files.single.path!);
    //
    // int minSize = min(value.width, value.height);
    // int minCount = min(configLogic.config.row, configLogic.config.column);
    // int count = minSize.clamp(0, minCount);
    // double rate = minSize/count;
    //
    //
    // configLogic.updateColumn(count);
    // configLogic.updateRow(count);
    // print(value.width);
    // for (int x = 0; x < count; x++) {
    //   for (int y = 0; y < count; y++) {
    //     var pixel = value.getPixel((y*rate).toInt(), (x*rate).toInt(),);
    //     var color = Color.fromARGB(
    //         pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
    //     if (color != Colors.transparent) {
    //       cells.add(PixCell(color: color, position: (y, x)));
    //     }
    //   }
    // }
    // paintLogic.setPixCells(cells);
  }
}
