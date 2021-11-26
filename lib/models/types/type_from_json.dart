import 'package:flutter/material.dart';
import 'package:kampus_sggw/logic/maps/icon_map.dart';
import 'package:kampus_sggw/models/map_object_application.dart';

abstract class TypeFromJson {
  String name;
  String materialIconName;
  ObjectFunctionGroup functionGroup;
  IconData _iconData;

  TypeFromJson({
    this.name,
    this.materialIconName,
    this.functionGroup,
  }) {
    _setIconData();
  }
  IconData get iconData => _iconData;

  void _setIconData() => _iconData = iconMap[materialIconName];
}
