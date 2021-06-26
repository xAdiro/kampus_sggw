import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kampus_sggw/models/map_item.dart';
import 'package:kampus_sggw/models/map_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_history.g.dart';

@JsonSerializable()
class UserHistory extends ChangeNotifier {
  @JsonKey(defaultValue: 6)
  int buffer;
  @JsonKey(defaultValue: <int>[])
  List<int> itemsIds;
  @JsonKey(ignore: true)
  List<MapItem> _storedMapItems;

  UserHistory({this.buffer, this.itemsIds});

  factory UserHistory.fromJson(Map<String, dynamic> json) =>
      _$UserHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$UserHistoryToJson(this);

  UnmodifiableListView<MapItem> get storedMapItems =>
      UnmodifiableListView(_storedMapItems);

  void loadMapItems(MapItems mapItems) {
    _storedMapItems = mapItems.getItems(itemsIds).reversed.toList();
  }

  @protected
  void addItem(MapItem mapItem) {
    _putAtFirstPosition(mapItem);
    itemsIds.add(mapItem.id);
    _trimListToBuffer();
  }

  @protected
  void deleteItem(MapItem mapItem) {
    itemsIds.removeWhere((id) => id == mapItem.id);
    _storedMapItems.removeWhere((item) => item.id == mapItem.id);
  }

  @protected
  void saveToJson(String sharedPrefKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(this.toJson());
    await sharedPreferences.setString(sharedPrefKey, jsonString);
  }

  @protected
  static Future<String> getJSONString(String sharedPrefKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(sharedPrefKey) ?? "{}";
  }

  void _trimListToBuffer() {
    if (itemsIds.length > buffer) {
      itemsIds.removeRange(0, 1);
    }
  }

  void _putAtFirstPosition(MapItem mapItem) {
    itemsIds.removeWhere((id) => id == mapItem.id);
  }
}
