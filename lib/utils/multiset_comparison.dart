import 'package:collection/collection.dart';

bool areListsEqualMultiset<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) return false;

  Map<T, int> frequencyMap(List<T> list) {
    var map = <T, int>{};
    for (var item in list) {
      map[item] = (map[item] ?? 0) + 1;
    }
    return map;
  }

  return DeepCollectionEquality().equals(frequencyMap(list1), frequencyMap(list2));
}