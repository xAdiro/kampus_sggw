import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:kampus_sggw/logic/user_history.dart';
import 'package:kampus_sggw/models/map_item.dart';
import 'package:kampus_sggw/models/map_items.dart';
part 'search_history.g.dart';

@JsonSerializable()
class SearchHistory extends UserHistory {
  @JsonKey(ignore: true)
  List<MapItem> _searchedItems;

  SearchHistory({int buffer, List<int> itemsIds})
      : super(buffer: buffer, itemsIds: itemsIds);

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);

  List<MapItem> filterSearchHistory({String query}) {
    if (query != null && query.isNotEmpty) {
      return _getItemsWhichNameStartsWith(query);
    } else {
      return _searchedItems;
    }
  }

  @override
  List<MapItem> updateMapItems(MapItems mapItems) {
    _searchedItems = super.updateMapItems(mapItems);
    return _searchedItems;
  }

  void save() async {
    super.saveToJson('searchHistory');
  }

  @override
  void addItem(MapItem mapItem) {
    super.addItem(mapItem);
    save();
  }

  @override
  void deleteItem(MapItem mapItem) {
    super.deleteItem(mapItem);
    save();
  }

  static Future<SearchHistory> loadFromJSON() async {
    String jsonString = await UserHistory.getJSONString('searchHistory');
    Map<String, dynamic> map = jsonDecode(jsonString);
    return SearchHistory.fromJson(map);
  }

  List<MapItem> _getItemsWhichNameStartsWith(String query) {
    return _searchedItems.where((item) => item.name.startsWith(query)).toList();
  }
}
