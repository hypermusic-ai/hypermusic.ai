import 'package:collection/collection.dart';

bool areListsEqualMultiset(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) return false;

  Map<dynamic, int> frequencyMap(List<dynamic> list) {
    var map = <dynamic, int>{};
    for (var item in list) {
      map[item] = (map[item] ?? 0) + 1;
    }
    return map;
  }

  return DeepCollectionEquality().equals(frequencyMap(list1), frequencyMap(list2));
}