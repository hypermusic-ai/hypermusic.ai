import 'package:collection/collection.dart';

// Utils
import '../utils/multiset_comparison.dart';

// Models
import 'transformation.dart';

class Feature 
{
  final String name;
  final String description;
  final List<Feature> composites;
  final Map<Feature, List<Transformation>> transformationsMap;
  final String condition;

  const Feature({
    required this.name,
    required this.description,
    required this.composites,
    required this.transformationsMap,
    this.condition = 'true',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'composites': composites,
      'transformationsMap': transformationsMap,
      'condition': condition,
    };
  }

  Feature copyWith({String? name, String? description, List<Feature>? composites, Map<Feature, List<Transformation>>? transformationsMap, String? condition}) {
  
    List<Feature> compositesDeepCopy = [];
    for (var key in (composites ?? this.composites)) {
        compositesDeepCopy.add(key);
    }

    Map<Feature, List<Transformation>> transformDeepCopy = {};

     (transformationsMap ?? this.transformationsMap).forEach((key, value) {
      // For each list in the map, create a new list with deep copies of the objects
      transformDeepCopy[key] = value.map((transformation) {return transformation;}).toList();
    });

    return Feature(
      name: name ?? this.name,
      description: description ?? this.description,
      composites: compositesDeepCopy,
      transformationsMap: transformDeepCopy,
      condition: condition ?? this.condition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Feature) return false;

    return name == other.name &&
        description == other.description &&
        areListsEqualMultiset(composites, other.composites) &&
        const DeepCollectionEquality().equals(transformationsMap, other.transformationsMap) &&
        condition == other.condition;
  }

  @override
  int get hashCode => Object.hash(
        name,
        description,
        const ListEquality().hash(composites),
        const DeepCollectionEquality().hash(transformationsMap),
        condition,
      );

  bool isScalar() => composites.isEmpty;
  
  int getScalarsCount() => composites.fold(0, (sum, composite) => sum + composite.getScalarsCount());
  
  int getSubTreeSize() {
    if (isScalar()) return 0;
    return composites.length + composites.fold(0, (sum, composite) => sum + composite.getSubTreeSize());
  }

  bool checkCondition() {
    // For now, only support 'true' and 'false' conditions
    return condition == 'true';
  }

  Map<String, dynamic> transform(int dimId, int opId, int x) {

    if (dimId >= composites.length) throw Exception('Invalid dimension id');

    final subFeature = composites[dimId];
    final transformations = transformationsMap[subFeature] ?? [];
    if (transformations.isEmpty) return {'value': x};

    final actualOpId = opId % transformations.length;
    final transformation = transformations[actualOpId];

    final name = transformation.name;
    if (name == 'Add') {
      final args = transformation.args;
      return {'value': x + args[0]};
    } else if (name == 'Mul') {
      final args = transformation.args;
      return {'value': x * args[0]};
    } else if (name == 'Nop') {
      return {'value': x};
    }

    return {'value': x}; // Default no-op
  }
}
