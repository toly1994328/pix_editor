import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/button/toly_icon_button.dart';

class MenuToolBar extends StatelessWidget {
  const MenuToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);

    return Container(
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xfff0f0f0),
        border: Border(bottom: side),
      ),
      child: Row(
        children: [
          Spacer(),
          TolyIconButton(
            size: Size(20,20),
            icon: Icon(CupertinoIcons.delete_solid,size: 16,),
            onPressed: () {},
          ),
          const SizedBox(width: 6,),
          TolyIconButton(
            size: Size(20,20),
            icon: Icon(Icons.save,size: 16,),
            onPressed: () {},
          ),
          const SizedBox(width: 12,)
        ],
      ),
    );
  }
}
