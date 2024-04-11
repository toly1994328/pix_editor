import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);

    return Container(
      height: 20,
      decoration: BoxDecoration(
          color: const Color(0xfff0f0f0),),
    );
  }
}
