import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TolyColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChange;

  const TolyColorPicker({
    super.key,
    required this.color,
    required this.onChange,
  });

  @override
  State<TolyColorPicker> createState() => _TolyColorPickerState();
}

class _TolyColorPickerState extends State<TolyColorPicker> {

  late Color _activeColor = widget.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showColorPicker(context),
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all()),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final textController = TextEditingController(text: '#${widget.color.value.toRadixString(16)}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: Column(
            children: [
              SizedBox(
                height: 46,
                child: NavigationToolbar(
                  middle: Text("选择颜色"),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(onPressed: () {
                      widget.onChange(_activeColor);

                      Navigator.of(context).pop();
                    }, child: Text('确定')),
                  ),
                ),
              ),
              ColorPicker(
                // pickerHsvColor:HSVColor.fromColor(_activeColor),
                pickerColor: Colors.redAccent,

                onColorChanged: (v){
                  _activeColor = v;
                },
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.7,
                enableAlpha: true,
                // hexInputController will respect it too.
                displayThumbColor: true,
                paletteType: PaletteType.hsv,
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2.0),
                  topRight: const Radius.circular(2.0),
                ),
                hexInputController: textController,
                // <- here
                portraitOnly: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                /* It can be any text field, for example:
                  * TextField
                  * TextFormField
                  * CupertinoTextField
                  * EditableText
                  * any text field from 3-rd party package
                  * your own text field
                  so basically anything that supports/uses
                  a TextEditingController for an editable text.
                  */
                child: CupertinoTextField(
                  controller: textController,
                  // Everything below is purely optional.
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: const Icon(Icons.tag),
                  ),
                  // suffix: IconButton(
                  //   icon:
                  //   const Icon(Icons.content_paste_rounded),
                  //   onPressed: () async =>
                  //       copyToClipboard(textController.text),
                  // ),
                  autofocus: true,
                  maxLength: 9,
                  // inputFormatters: [
                  //   // Any custom input formatter can be passed
                  //   // here or use any Form validator you want.
                  //   UpperCaseTextFormatter(),
                  //   FilteringTextInputFormatter.allow(
                  //       RegExp(kValidHexPattern)),
                  // ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
