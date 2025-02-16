import 'dart:developer' as developer;
import 'package:collection/collection.dart';

// Utils
import '../utils/multiset_comparison.dart';
import '../utils/map_comparison.dart';

// Models
import 'transformation.dart';
import 'condition.dart';
import 'running_instance.dart';

class Feature
{
  String name;
  final String description;
  final List<Feature> composites;
  final Map<Feature, List<TransformationDef>> transformationDefs;
  final Map<Feature, List<RunningInstance>> runningInstances;
  final Condition? condition;

  Feature({
    required this.name,
    required this.description,
    required this.composites,
    required this.transformationDefs,
    required this.runningInstances,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'composites': composites,
      'transformationDefs': transformationDefs,
      'runningInstances': runningInstances,
      'condition': condition,
    };
  }

  /// Create Feature object from JSON
  factory Feature.fromJson(Map<String, dynamic> json) {
     return Feature(
      name: json['name'],
      description: json['description'],
      composites: json['composites'],
      transformationDefs: json['transformationDefs'],
      runningInstances: json['runningInstances'],
      condition: json['condition'],
    );
  }

  Feature copyWith({
      String? name,
      String? description,
      List<Feature>? composites,
      Map<Feature, List<TransformationDef>>? transformationDefs,
      Map<Feature, List<RunningInstance>>?  runningInstances,
      Condition? condition
     }) 
  {
    developer.log('deppcopy feature ${this.name}', name: 'hypermusic.feature');

    List<Feature> compositesDeepCopy = [];
    for (Feature key in (composites ?? this.composites)) {
        compositesDeepCopy.add(key.copyWith());
    }

    Map<Feature, List<TransformationDef>> transformDeepCopy = {};
     (transformationDefs ?? this.transformationDefs).forEach((key, value) {
      transformDeepCopy[key] = value.map((transformationDef) {return transformationDef.copyWith();}).toList();
    });

    Map<Feature, List<RunningInstance>> runningInstancesDeepCopy = {};
     (runningInstances ?? this.runningInstances).forEach((key, value) {
      runningInstancesDeepCopy[key] = value.map((runningInstance) {return runningInstance.copyWith();}).toList();
    });

    return Feature(
      name: name ?? this.name,
      description: description ?? this.description,
      composites: compositesDeepCopy,
      transformationDefs: transformDeepCopy,
      condition: condition ?? this.condition?.copyWith(),
      runningInstances: runningInstancesDeepCopy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Feature) return false;

    return name == other.name &&
        description == other.description &&
        areListsEqualMultiset(composites, other.composites) &&
        areMapsOfListsEqual(transformationDefs, other.transformationDefs) &&
        condition == other.condition;
  }

  @override
  int get hashCode => Object.hash(
        name,
        description,
        const ListEquality().hash(composites),
        //const MapEquality(keys: IdentityEquality(), values: ListEquality()).hash(transformationDefs),
        condition,
      );

  bool isScalar() => composites.isEmpty;
  
  int getScalarsCount() => composites.fold(0, (sum, composite) => sum + composite.getScalarsCount());
  
  int getSubTreeSize() {
    if (isScalar()) return 0;
    return composites.length + composites.fold(0, (sum, composite) => sum + composite.getSubTreeSize());
  }

  bool checkCondition(List<dynamic> args) {
    if(condition == null) return true;
    return condition!.check(args);
  }

  int transform(int dimId, int opId, int index) {

    if (dimId >= composites.length) throw Exception('Invalid dimension id');

    final List<TransformationDef> transformationDefsList = transformationDefs[composites[dimId]] ?? [];
    if (transformationDefsList.isEmpty) return index;

    opId = opId % transformationDefsList.length;

    return transformationDefsList[opId].transformation.run(index, transformationDefsList[opId].args);
  }
}
