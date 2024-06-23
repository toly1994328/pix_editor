import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pix_editor/bloc/view_camera.dart';
import 'package:uuid/uuid.dart';

import '../data/image_layer.dart';
import '../data/layer/pix_layer.dart';
import '../data/pix_cell.dart';

class PixPaintLogic with ChangeNotifier, ViewCamera {
  String activeLayerId = '';
  final List<PaintLayer> _layers = [];

  PixLayer get activePixLayer =>
      _layers.whereType<PixLayer>().singleWhere((e) => e.id == activeLayerId);

  int get row => activePixLayer.row;

  int get column => activePixLayer.column;

  List<PixCell> get pixCells => activePixLayer.pixCells;

  late TextEditingController rowCtrl = TextEditingController(text: row.toString());

  late TextEditingController columnCtrl = TextEditingController(text: column.toString());

  PixPaintLogic() {
    addPixLayer();
  }

  @override
  void dispose() {
    rowCtrl.dispose();
    columnCtrl.dispose();
    super.dispose();
  }

  void changeActiveLayer(String layerId) {
    activeLayerId = layerId;
    PixLayer layer = activePixLayer;
    updateRow('${layer.row}');
    updateColumn('${layer.column}');
    activePixLayer.update(this);
    notifyListeners();
  }

  void updateColumn(String value, {bool notify = true}) {
    int? column = int.tryParse(value);
    if (column != null && column > 0 && column <= 256) {
      columnCtrl.text = column.toString();
      activePixLayer.column = column;
      changeGridSize();
      if (notify) {
        notifyListeners();
        activePixLayer.update(this);
      }
    }
  }

  void updateRow(String value, {bool notify = true}) {
    int? row = int.tryParse(value);
    if (row != null && row > 0 && row <= 256) {
      rowCtrl.text = row.toString();
      activePixLayer.row = row;
      changeGridSize();
      if (notify) {
        notifyListeners();
        activePixLayer.update(this);
      }
    }
  }

  void addPixLayer() {
    int activeIndex = 0;
    if (activeLayerId.isNotEmpty) {
      activeIndex = _layers.indexWhere((e) => e.id == activeLayerId);
    }
    String id = const Uuid().v4();
    PixLayer pixLayer = PixLayer(name: "像素图层", row: 32, column: 32, pixCells: [], id: id)
      ..update(this);
    _layers.insert(activeIndex, pixLayer);
    changeActiveLayer(id);
  }

  List<PaintLayer> get layers => _layers;

  Color get paintColor => _paintColor;

  set paintColor(Color value) {
    _paintColor = value;
    notifyListeners();
  }

  Color _paintColor = const Color(0xff5ec8f8);

  void removeActiveLayer() {
    if (_layers.length == 1) {
      return;
      _layers.clear();
      notifyListeners();
      return;
    }
    int currentIndex = 0;
    int activeIndex = 0;
    if (activeLayerId.isNotEmpty) {
      currentIndex = _layers.indexWhere((e) => e.id == activeLayerId);
    }
    if (currentIndex == _layers.length - 1) {
      activeIndex = currentIndex - 1;
    } else {
      activeIndex = currentIndex + 1;
    }
    activeLayerId = _layers[activeIndex].id;
    _layers.removeAt(currentIndex);
    changeActiveLayer(activeLayerId);
  }

  void setPixCells(List<PixCell> cells) {
    pixCells.clear();
    pixCells.addAll(cells);
    notifyListeners();
    activePixLayer.update(this);
  }

  void setImage(String filePath) async {
    File file = File(filePath);
    img.Image? pixImage = img.decodeImage(await file.readAsBytes());
    if (pixImage == null) {
      return;
    }

    // ImageLayer layer = await ImageLayer.formFile(filePath);
    // layer.updatePicture();
    // if (layer.image == null) return;
    // _layers.insert(0,layer);
    setPixByImage(pixImage);
  }

  void setPixByImage(img.Image image) {
    List<PixCell> cells = [];
    int width = image.width;
    int height = image.height;
    if (width / height != 1) {
      int newColumn = (row * (height / width)).ceil();
      updateColumn('$newColumn', notify: false);
    }

    // int minSize = min(image.width, image.height);
    // int minCount = min(row, column);
    // int count = minSize.clamp(0, minCount);
    double rateX = image.width / row;
    double rateY = image.height / column;

    for (int x = 0; x < column; x++) {
      for (int y = 0; y < row; y++) {
        var pixel = image.getPixel((y * rateY).toInt(), (x * rateX).toInt());
        var color =
            Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        if (color != Colors.transparent) {
          cells.add(PixCell(color: color, position: (y, x)));
        }
      }
    }
    setPixCells(cells);
  }

  @override
  (int, int) get gridSize => (activePixLayer.row, activePixLayer.column);

  @override
  void onViewBoxChanged(Size old, Size size) {
    super.onViewBoxChanged(old, size);
    activePixLayer.update(this);
    notifyListeners();
  }

  void handleTap(Offset localPosition, {PixAction action = PixAction.add}) {
    (int, int) point = transformPoint(localPosition);
    int x = point.$1;
    int y = point.$2;
    if (x < 0 || y < 0 || x > row || y > column) return;
    switch (action) {
      case PixAction.add:
        addPix(x, y);
        break;
      case PixAction.delete:
        removePix(x, y);
        break;
    }
    activePixLayer.update(this);
    notifyListeners();
  }

  void addPix(int x, int y) {
    pixCells.removeWhere((e) => e.position == (x, y));
    pixCells.add(PixCell(color: _paintColor, position: (x, y)));
  }

  void removePix(int x, int y) {
    bool hasPix = pixCells.where((e) => e.position == (x, y)).isNotEmpty;
    if (hasPix) {
      pixCells.removeWhere((e) => e.position == (x, y));
    }
  }
}

enum PixAction { add, delete }

class PixPaintScope extends InheritedNotifier<PixPaintLogic> {
  const PixPaintScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static PixPaintLogic of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PixPaintScope>()!.notifier!;

  static PixPaintLogic read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<PixPaintScope>()!.notifier!;
}
