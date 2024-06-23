import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu/menu_action.dart';
import 'menu/menu_entry.dart';

class AppToolMenuBar extends StatefulWidget {
  final ValueChanged<MenuAction?> onTapMenu;

  const AppToolMenuBar({
    super.key,
    required this.onTapMenu,
  });

  @override
  State<AppToolMenuBar> createState() => _AppToolMenuBarState();
}

class _AppToolMenuBarState extends State<AppToolMenuBar> {
  ShortcutRegistryEntry? _shortcutsEntry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shortcutRegistry([...fileMenus, ...editMenus]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).appBarTheme.backgroundColor,
      height: 30,
      child: Column(
        children: [
          const Divider(),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(spacing: 6, children: [
                      MenuItem(
                        label: '文件',
                        menuChildren: buildByMenuEntryList(fileMenus, widget.onTapMenu),
                      ),
                      MenuItem(
                        label: '编辑',
                        menuChildren: buildByMenuEntryList(editMenus, widget.onTapMenu),
                      ),
                    ]),
                  ))),
          // Divider(),
        ],
      ),
    );
  }

  List<MenuEntry> get fileMenus => const <MenuEntry>[
      MenuEntry(
        action: MenuAction.newFile,
        label: '新建',
        shortcut: SingleActivator(LogicalKeyboardKey.keyN, control: true),
      ),
      MenuEntry(
        action: MenuAction.openFile,
        label: '打开',
        shortcut: SingleActivator(LogicalKeyboardKey.keyO, control: true),
      ),
      MenuEntry(
        action: MenuAction.importFile,
        label: '导入',
        shortcut: SingleActivator(LogicalKeyboardKey.keyI, control: true),
      ),
      MenuEntry(
        action: MenuAction.saveFile,
        label: '保存',
        shortcut: SingleActivator(LogicalKeyboardKey.keyS, control: true),
      ),
      MenuEntry(
        label: '导出为',
        menuChildren: <MenuEntry>[
          MenuEntry(label: 'PNG', tail: '.png',action: MenuAction.outputFilePng),
          MenuEntry(label: 'JPG', tail: '.jpg',action: MenuAction.outputFileJpg),
          MenuEntry(label: 'SVG', tail: '.svg',action: MenuAction.outputFileSvg),
        ],
      ),
    ];

  List<MenuEntry> get editMenus => const <MenuEntry>[
      MenuEntry(
        label: '撤销',
        shortcut: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
      ),
      MenuEntry(
        label: '重做',
        shortcut: SingleActivator(LogicalKeyboardKey.keyZ,
            control: true, shift: true),
      ),
      // Hides the message, but is only enabled if the message isn't
      // already hidden.
      MenuEntry(
        label: '拷贝',
        shortcut: SingleActivator(LogicalKeyboardKey.keyC, control: true),
      ),
      MenuEntry(
        label: '粘贴',
        shortcut: SingleActivator(LogicalKeyboardKey.keyV, control: true),
      ),
      MenuEntry(
        label: '变换',
        menuChildren: <MenuEntry>[
          MenuEntry(label: '平移'),
          MenuEntry(label: '旋转'),
          MenuEntry(label: '缩放'),
        ],
      ),
    ];


  void _shortcutRegistry(List<MenuEntry> result) {
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry = ShortcutRegistry.of(context)
        .addAll(shortcutsByMenuEntryList(result, widget.onTapMenu));
  }
}

class MenuItem extends StatefulWidget {
  final String label;
  final List<Widget> menuChildren;

  const MenuItem({super.key, required this.label, required this.menuChildren});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  final MenuController _menuController = MenuController();
  bool _hover = false;
  bool _opened = false;

  Color get bgColor => (_hover || _opened)
      ? const Color(0xff353535).withOpacity(0.1)
      : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
        onOpen: () {
          setState(() {
            _opened = true;
          });
        },
        onClose: () {
          _opened = false;
        },
        controller: _menuController,
        menuChildren: widget.menuChildren,
        alignmentOffset: const Offset(0, 2),
        builder: (ctx, ctrl, child) {
          return MouseRegion(
            // cursor: SystemMouseCursors.click,
            onExit: _onExit,
            onEnter: _onEnter,
            child: GestureDetector(
                onTapDown: _handleTapDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                  decoration: BoxDecoration(
                      color: bgColor, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    widget.label,
                  ),
                )),
          );
        });
  }

  void _handleTapDown(TapDownDetails details) {
    _menuController.open();
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }
}
