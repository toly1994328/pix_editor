import 'dart:ui';

abstract class PaintLayer {
  static Size kPaintViewPort = const Size(1024, 1024);
  String name;
  final String id;

  late Picture picture;

  PaintLayer({
    required this.id,
    this.name = '新建图层',
  });


  void update() {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    paint(canvas, kPaintViewPort);
    picture = recorder.endRecording();
  }

  void paint(Canvas canvas, Size size);
}
