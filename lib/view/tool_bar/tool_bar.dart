import 'package:flutter/material.dart';
import 'package:pix_editor/app/res/toly_icon.dart';

import '../../components/button/toly_icon_button.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);

    return Container(
      padding: EdgeInsets.only(top: 8),
      width: 32,
      decoration: BoxDecoration(
        color: const Color(0xfff0f0f0),
        border: Border(right: side),
      ),
      child: Column(
        children: [
          TolyIconButton(
            size: Size(24,24),
            icon: Icon(TolyIcon.iconSelector,size: 18,),
            onPressed: () {},
          ),
          const SizedBox(height: 4,),
          TolyIconButton(
            select: true,
            size: Size(24,24),
            icon: Icon(TolyIcon.iconPainter,size: 18,),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
