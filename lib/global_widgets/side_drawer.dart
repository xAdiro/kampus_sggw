import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kampus_sggw/translations/locale_keys.g.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 80.0,
            child: DrawerHeader(
              child: Text(LocaleKeys.map_screen_title.tr(), style: TextStyle(color: Theme.of(context).bannerTheme.contentTextStyle.color),),
              decoration: BoxDecoration(
                color: Theme.of(context).bannerTheme.backgroundColor
              ),
            ),
          ),
          ListTile(
            title: Text(LocaleKeys.drawer_settings.tr()),
            onTap: () {},
          ),
          ListTile(
            title: Text(LocaleKeys.drawer_campus_rules.tr()),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
