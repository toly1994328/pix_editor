import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'package:pix_editor/data/pix_cell.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/view_camera.dart';
import '../image_layer.dart';

class ImageLayer extends PaintLayer {
  final img.Image? image;
  final ui.Image? paintImage;
  final Rect zone;

  ImageLayer({
    required this.paintImage,
    required this.image,
    required this.zone,
    super.name = "图片图层",
    required super.id,
  });

  static Future<ImageLayer> formFile(String filePath) async {
    File file = File(filePath);
    Uint8List data = await file.readAsBytes();
    img.Image? pixImage = img.decodeImage(await file.readAsBytes());
    ui.Image? pImage = await decodeImageFromList(data);

    return ImageLayer(
      paintImage: pImage,
      image: pixImage,
      zone: Rect.zero,
      id: const Uuid().v4(),
    );
  }

  @override
  void paint(Canvas canvas, ViewCamera camera) {
    if (paintImage != null) {
      canvas.drawImageRect(
          paintImage!,
          Offset.zero & Size(paintImage!.width.toDouble(), paintImage!.height.toDouble()),
          Offset.zero & camera.playSize,
          Paint());
    }
  }
}
