import 'list_comparison.dart';

bool areMapsOfListsEqual<K, V>(Map<K, List<V>> map1, Map<K, List<V>> map2) {
  if (map1.length != map2.length) return false;

  for (var entry in map1.entries) {
    var otherEntry = map2[entry.key];
    if (otherEntry == null || !areListsEqual(entry.value, otherEntry)) {
      return false;
    }
  }

  return true;
}