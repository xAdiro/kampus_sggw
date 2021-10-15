import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kampus_sggw/logic/event_parameters/suggested_item.dart';
import 'package:kampus_sggw/models/map_item.dart';
import 'package:kampus_sggw/models/map_item_types/map_item_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kampus_sggw/models/map_object_application.dart';
import 'package:kampus_sggw/models/service.dart';
import 'package:fuzzy/fuzzy.dart';
part 'map_items.g.dart';

@JsonSerializable()
class MapItems extends ChangeNotifier {
  static final storage = GetStorage();

  List<MapItem> mapItems;
  @JsonKey(ignore: true)
  Map<MapItem, Fuzzy> fuzzySetItemMap;
  MapItems(
    this.mapItems,
  );

  static Future<MapItems> load() async {
    MapItems mapItems = await _loadFromJSON();
    mapItems.bindWithItemTypes(await MapItemTypes.loadFromJSON());
    mapItems.generateFuzzyStringSetForMapItems();
    return mapItems;
  }

  static Future<MapItems> _loadFromJSON() async {
    Map<String, dynamic> mapItemsMap = jsonDecode(_getJsonString());
    MapItems mapItems = MapItems.fromJson(mapItemsMap);
    return mapItems;
  }

  Set<MapItem> filterByServices(List<ServiceType> serviceTypes) {
    Set<MapItem> filteredItems = {};
    mapItems.forEach((item) {
      if (item.containsAtLeastOneServiceType(serviceTypes)) {
        filteredItems.add(item);
      }
    });
    return filteredItems;
  }

  Set<MapItem> filterByTypeCategory(MapObjectApplication objectApplication) {
    Set<MapItem> filteredItems = {};
    mapItems.forEach((item) {
      if (item.metaCategory() == objectApplication) {
        filteredItems.add(item);
      }
    });
    return filteredItems;
  }

  factory MapItems.fromJson(Map<String, dynamic> json) =>
      _$MapItemsFromJson(json);

  static String _getJsonString() {
    return storage.read('map_items_content');
  }

  void generateFuzzyStringSetForMapItems() {
    mapItems.forEach((item) {
      item.generateFuzzySet();
    });
  }

  void bindWithItemTypes(MapItemTypes mapItemTypes) {
    print(mapItemTypes.mapItemTypes.length);
    mapItems.forEach((item) {
      item.setType(mapItemTypes);
    });
  }

  List<MapItem> getItems(List<int> itemsIds) {
    List<MapItem> tmp = [];
    for (var id in itemsIds) {
      tmp.add(mapItems.firstWhere((element) => element.id == id));
    }
    return tmp;
  }

  MapItem findItemByQuery(String query) {
    List<SuggestedItem> similarItems = findItemsByQuery(query);
    return similarItems.length > 0 ? similarItems[0].mapItem : null;
  }

  MapItem findItemByID(int id) {
    return mapItems.firstWhere((element) => element.id == id);
  }

  List<SuggestedItem> findItemsByQuery(String query) {
    List<SuggestedItem> similarityList =
        _getSimilarityMapForEachItem(query.toLowerCase());
    return _getMostSimilarMapItems(similarityList);
  }

  List<SuggestedItem> _getSimilarityMapForEachItem(String query) {
    List<SuggestedItem> similarityList = [];
    mapItems.forEach(
      (item) {
        var similarity = item.searchingSet.search(query);
        if (similarity.length > 0) {
          similarityList.add(
            SuggestedItem(
              mapItem: item,
              matchedQuery: similarity[0].item,
              similarity: similarity[0].score,
            ),
          );
        }
      },
    );
    return similarityList;
  }

  List<SuggestedItem> _getMostSimilarMapItems(
      List<SuggestedItem> similarityList) {
    similarityList.sort((a, b) => a.similarity.compareTo(b.similarity));
    return similarityList.take(6).toList();
  }
}
