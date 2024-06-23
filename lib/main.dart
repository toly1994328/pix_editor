import 'package:flutter/material.dart';
import 'package:platform_adapter/platform_adapter.dart';

import 'app/theme/theme.dart';
import 'view/pix_editor_page.dart';

void main() {
  runApp(const MyApp());
  WindowSizeAdapter.setSize(minimumSize: Size(40, 40));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: PixEditorScope(),
    );
  }
}
