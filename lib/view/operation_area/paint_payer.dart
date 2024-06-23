import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pix_editor/bloc/pix_paint_logic.dart';

import '../../components/button/toly_icon_button.dart';
import '../../data/image_layer.dart';
import 'slider_item_wrapper.dart';

class PainterLayer extends StatelessWidget {
  const PainterLayer({super.key});

  @override
  Widget build(BuildContext context) {
    PixPaintLogic logic = PixPaintScope.of(context);
    List<PaintLayer> layers = logic.layers;
    return ClipRRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            color: Color(0xffdbdbdb),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Text(
              "图层",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: SlidableAutoCloseBehavior(
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => LayerItem(
                onSelectLayer: (layer) {
                  logic.changeActiveLayer(layer.id);
                },
                active: layers[index].id == logic.activeLayerId,
                layer: layers[index],
              ),
              itemCount: layers.length,
            ),
          )),
          Divider(),
          ColoredBox(
            color: Color(0xfff0f0f0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Row(
                children: [
                  const Spacer(),
                  TolyIconButton(
                    size: Size(20, 20),
                    icon: Icon(
                      CupertinoIcons.pencil_circle,
                      size: 16,
                    ),
                    onPressed: () {
                      PixPaintScope.of(context).addPixLayer();
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  TolyIconButton(
                    size: Size(20, 20),
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      size: 16,
                    ),
                    onPressed: () {
                      PixPaintScope.of(context).addPixLayer();
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  TolyIconButton(
                    size: Size(20, 20),
                    icon: Icon(
                      CupertinoIcons.delete,
                      size: 16,
                    ),
                    onPressed: () {
                      PixPaintScope.of(context).removeActiveLayer();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LayerItem extends StatelessWidget {
  final bool active;
  final PaintLayer layer;
  final ValueChanged<PaintLayer> onSelectLayer;

  const LayerItem(
      {super.key, required this.active, required this.layer, required this.onSelectLayer});

  @override
  Widget build(BuildContext context) {
    return SliderItemWrapper(
      uniqueId: layer.id,
      onDelete: (BuildContext context) {
        PixPaintScope.of(context).removeActiveLayer();
      },
      onEdit: (BuildContext context) {},
      child: GestureDetector(
        onTap: () => onSelectLayer(layer),
        child: Container(
          color: Color(0xfff0f0f0),
          height: 38,
          child: Row(
            children: [
              Container(
                  width: 38,
                  child: Icon(
                    Icons.remove_red_eye,
                    size: 18,
                  )),
              VerticalDivider(),
              Expanded(
                child: ColoredBox(
                    color: active ? Color(0xffb5b5b5) : Color(0xfff0f0f0),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 32,
                              height: 24,
                              child: LayerPreview(
                                picture: layer.picture,
                                layerSize: layer.layerSize,
                              )),
                          Text(
                            layer.name,
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LayerPreview extends StatelessWidget {
  final Picture picture;
  final Size layerSize;

  const LayerPreview({
    super.key,
    required this.picture,
    required this.layerSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LayerPreviewPainter(picture, layerSize),
    );
  }
}

class LayerPreviewPainter extends CustomPainter {
  final Picture picture;
  final Size playSize;

  LayerPreviewPainter(this.picture, this.playSize);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    canvas.save();
    double rate;
    if (playSize.aspectRatio > 1) {
      rate = size.width / playSize.width;
      canvas.translate(0, (size.height - (rate * playSize.height)) / 2);
    } else {
      rate = size.height / playSize.height;
      canvas.translate((size.width - (rate * playSize.width)) / 2, 0);
    }
    canvas.scale(rate);
    canvas.drawPicture(picture);
    canvas.restore();
    canvas.drawRect(Offset.zero & size, Paint()..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant LayerPreviewPainter oldDelegate) {
    return picture != oldDelegate.picture;
  }
}
