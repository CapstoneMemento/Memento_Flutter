import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key? key, this.title, this.leading, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final Widget? title, leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
      shadowColor: const Color(0x55000000),
      elevation: 1,
    );
  }
}
