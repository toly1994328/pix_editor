import 'package:flutter/material.dart';

import 'menu_action.dart';

class MenuEntry {
  const MenuEntry({
    required this.label,
    this.action,
    this.tail,
    this.shortcut,
    this.menuChildren,
  });

  final String label;
  final String? tail;
  final MenuAction? action;

  final MenuSerializableShortcut? shortcut;
  final List<MenuEntry>? menuChildren;
}

Map<MenuSerializableShortcut, Intent> shortcutsByMenuEntryList(
    List<MenuEntry> selections, ValueChanged<MenuAction?> onTap) {
  final Map<MenuSerializableShortcut, Intent> result =
      <MenuSerializableShortcut, Intent>{};
  for (final MenuEntry selection in selections) {
    if (selection.menuChildren != null) {
      result.addAll(shortcutsByMenuEntryList(selection.menuChildren!, onTap));
    } else {
      if (selection.shortcut != null) {
        result[selection.shortcut!] =
            VoidCallbackIntent(() => onTap(selection.action));
      }
    }
  }
  return result;
}

List<Widget> buildByMenuEntryList(
    List<MenuEntry> selections, ValueChanged<MenuAction?> onTapMenu) {
  Widget buildSelection(MenuEntry selection) {
    Widget child = Text(selection.label);
    if (selection.tail != null) {
      child = Row(
        children: [
          child,
          const SizedBox(width: 20),
          Text(
            selection.tail!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      );
    }
    if (selection.menuChildren != null) {
      return SubmenuButton(
        menuChildren: buildByMenuEntryList(selection.menuChildren!, onTapMenu),
        child: child,
      );
    }
    return MenuItemButton(
      shortcut: selection.shortcut,
      onPressed: () => onTapMenu(selection.action),
      child: child,
    );
  }

  return selections.map<Widget>(buildSelection).toList();
}
