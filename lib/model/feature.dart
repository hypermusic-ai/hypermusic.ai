import 'package:tuple/tuple.dart';

typedef TransformFunctionDef = Tuple2<String, List<dynamic>>;

class Feature 
{
  final String name;
  final String description;
  final List<Feature> composites;
  //[featutename] -> List{Tuple2{string, List<dynamic>}}
  final Map<String, List<TransformFunctionDef>> transformationsMap;
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

  Feature copyWith({String? name, String? description, List<Feature>? composites, Map<String, List<TransformFunctionDef>>? transformationsMap, String? condition}) {
  
    List<Feature> compositesDeepCopy = [];
    for (var key in (composites ?? this.composites)) {
        compositesDeepCopy.add(key);
    }

    Map<String, List<TransformFunctionDef>> transformDeepCopy = {};
    (transformationsMap ?? this.transformationsMap).forEach((key, value) {
      // For each list in the map, create a new list with deep copies of the objects
      transformDeepCopy[key] = value.map((transformFunctionDef) {
        return Tuple2(transformFunctionDef.item1, List.from(transformFunctionDef.item2));
      }).toList();
    });

    return Feature(
      name: name ?? this.name,
      description: description ?? this.description,
      composites: compositesDeepCopy,
      transformationsMap: transformDeepCopy,
      condition: condition ?? this.condition,
    );
  }

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

    final name = transformation.item1;
    if (name == 'Add') {
      final args = transformation.item2 as List<int>;
      return {'value': x + args[0]};
    } else if (name == 'Mul') {
      final args = transformation.item2 as List<int>;
      return {'value': x * args[0]};
    } else if (name == 'Nop') {
      return {'value': x};
    }

    return {'value': x}; // Default no-op
  }
}
