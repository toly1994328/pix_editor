import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SliderItemWrapper extends StatelessWidget {
  final Widget child;
  final String uniqueId;
  final SlidableActionCallback onDelete;
  final SlidableActionCallback onEdit;

  const SliderItemWrapper({
    super.key,
    required this.child,
    required this.uniqueId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(uniqueId),
      groupTag: 'all',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: _buildButtons(),
      ),
      child: child
    );
  }

  List<Widget> _buildButtons() => [
        SlidableAction(
          flex: 2,
          onPressed: onEdit,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          // label: '修改',
        ),
        SlidableAction(
          flex: 2,
          onPressed: onDelete,
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          padding: EdgeInsets.zero,
          // label: '删除',
        ),
      ];
}
