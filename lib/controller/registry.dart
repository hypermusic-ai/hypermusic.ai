// Models
import '../model/version.dart';
import '../model/feature.dart';
import '../model/running_instance.dart';
import '../model/condition.dart';
import '../model/transformation.dart';

// Constrollers
import 'data_interface.dart';

class Registry implements DataInterface 
{
  // [featureName] = featureVersion
  final Map<String, Version<Feature>> _newestFeatureVersion = {};
  // [featureName][featureVersion] = Feature
  final Map<String, Map<Version<Feature>, Feature>> _features = {};

  // [riVersion] = RunningInstance
  final Map<Version<RunningInstance>,  RunningInstance> _runningInstances = {};

  // [conditionName] = conditionVersion
  final Map<String,  Version<Condition>> _newestCondition = {};
  // [conditionName][conditionVersion] = Condition
  final Map<String, Map<Version<Condition>, Condition>> _conditions = {};

  // [transformationName] = transformationVersion
  final Map<String, Version<Transformation>> _newestTransformation = {};
  // [transformationName][transformationVersion] = Transformation
  final Map<String, Map<Version<Transformation>, Transformation>> _transformations = {};

  @override
  Future<Version<Feature>?> registerFeature(Feature feature) async
  {
    // construct new bucket
    if(_features.containsKey(feature.name) == false)
    {
      _features[feature.name] = {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final registrationId = Version<Feature>(hash: sha256FromString('feature_${feature.name}_$timestamp'));

    assert(_features[feature.name]!.containsKey(registrationId) == false, "already contains ${feature.name} with version $registrationId");
    if(_features[feature.name]!.containsKey(registrationId))return null;

    _features[feature.name]![registrationId] = feature;
    _newestFeatureVersion[feature.name] = registrationId;

    return registrationId;
  }

  @override
  Future<Version<Feature>?> containsFeature(Feature feature) async
  {
    if(_features.containsKey(feature.name) == false)return null;
    for(Version<Feature> version in _features[feature.name]!.keys)
    {
      if(_features[feature.name]![version] == feature)return version;
    }
    return null;
  }

  @override
  Future<Feature?> getNewestFeature(String featureName) async
  {
      return _features[featureName]?[_newestFeatureVersion[featureName]];
  }

  @override
  Future<List<Feature>> getAllFeatures(String featureName) async
  {
    if(_features[featureName] == null)return [];
    return _features[featureName]!.values.toList();
  }

  @override
  Future<Feature?> getFeature(String featureName, Version<Feature> featureVersion) async
  {
    return _features[featureName]?[featureVersion];
  }

  @override
  Future<List<String>> getAllFeatureNames() async
  {
    return _features.keys.toList();
  }

  @override
  Future<List<Version<Feature>>> getAllFeatureVersions(String featureName) async
  {
    if(_features.containsKey(featureName) == false)return [];
    return _features[featureName]!.keys.toList();
  }

  @override
  Future<bool> removeFeature(String featureName, Version<Feature> featureVersion) async
  {
    if(_features.containsKey(featureName) == false)return false;
    return _features[featureName]!.remove(featureVersion) != null;
  }

  @override
  Future<bool> removeAllFeatureVersions(String featureName) async
  {
    if(_features.containsKey(featureName) == false)return false;
    return _features.remove(featureName) != null;
  }


  @override
  Future<Version<RunningInstance>?> registerRunningInstance(RunningInstance instance)async
  {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final registrationId = Version<RunningInstance>(hash: sha256FromString('running_instance_$timestamp'));

    _runningInstances[registrationId] = instance;

    return registrationId;
  }

  @override
  Future<RunningInstance?> getRunningInstance(Version<RunningInstance> riVersion) async
  {
    if(_runningInstances.containsKey(riVersion) == false)return null;
    return _runningInstances[riVersion];
  }

  @override
  Future<bool> removeRunningInstance(Version<RunningInstance> riVersion) async
  {
    if(_runningInstances.containsKey(riVersion) == false)return false;
    return _runningInstances.remove(riVersion) != null;
  }

  @override
  Future<Version<Condition>?> registerCondition(Condition condition) async
  {
    // construct new bucket
    if(_conditions.containsKey(condition.name) == false)
    {
      _conditions[condition.name] = {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final registrationId = Version<Condition>(hash: sha256FromString('condition_${condition.name}_$timestamp'));

    assert(_conditions[condition.name]!.containsKey(registrationId) == false, "already contains ${condition.name} with version $registrationId");
    if(_conditions[condition.name]!.containsKey(registrationId))return null;

    _conditions[condition.name]![registrationId] = condition;
    _newestCondition[condition.name] = registrationId;

    return registrationId;
  }

  @override
  Future<Condition?> getCondition(String conditionName, Version<Condition> conditionVersion) async
  {
    return _conditions[conditionName]?[conditionVersion];
  }

  @override
  Future<Condition?> getNewestCondition(String conditionName) async
  {
      return _conditions[conditionName]?[_newestCondition[conditionName]];
  }
  
  @override
  Future<List<String>> getAllConditionsNames() async
  {
    return _conditions.keys.toList();
  }

  @override
  Future<List<Condition>> getAllConditions(String conditionName) async
  {
    if(_conditions[conditionName] == null)return [];
    return _conditions[conditionName]!.values.toList();
  }

  @override
  Future<List<Version<Condition>>> getAllConditionVersions(String conditionName) async
  {
    if(_conditions.containsKey(conditionName) == false)return [];
    return _conditions[conditionName]!.keys.toList();
  }

  @override
  Future<bool> removeCondition(String conditionName, Version<Condition> conditionVersion) async
  {
    if(_conditions.containsKey(conditionName) == false)return false;
    return _conditions[conditionName]!.remove(conditionVersion) != null;
  }

  @override
  Future<bool> removeAllConditionVersions(String conditionName) async
  {
    if(_conditions.containsKey(conditionName) == false)return false;
    return _conditions.remove(conditionName) != null;
  }


  @override
  Future<Version<Transformation>?> registerTransformation(Transformation transformation) async
  {
    // construct new bucket
    if(_transformations.containsKey(transformation.name) == false)
    {
      _transformations[transformation.name] = {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final registrationId = Version<Transformation>(hash: sha256FromString('transformation_${transformation.name}_$timestamp'));

    assert(_transformations[transformation.name]!.containsKey(registrationId) == false, "already contains ${transformation.name} with version $registrationId");
    if(_transformations[transformation.name]!.containsKey(registrationId))return null;

    _transformations[transformation.name]![registrationId] = transformation;
    _newestTransformation[transformation.name] = registrationId;

    return registrationId;
  }

  @override
  Future<Transformation?> getTransformation(String transformationName, Version<Transformation> transformationVersion) async
  {
    return _transformations[transformationName]?[transformationVersion];
  }

  @override
  Future<Transformation?> getNewestTransformation(String transformationName) async
  {
    return _transformations[transformationName]?[_newestTransformation[transformationName]];
  }

  @override
  Future<List<Transformation>> getAllTransformations(String transformationName) async
  {
    if(_transformations[transformationName] == null)return [];
    return _transformations[transformationName]!.values.toList();
  }

  @override
  Future<List<Version<Transformation>>> getAllTransformationVersions(String transformationName) async
  {
    if(_transformations.containsKey(transformationName) == false)return [];
    return _transformations[transformationName]!.keys.toList();
  }

  @override
  Future<List<String>> getAllTransformationsNames() async
  {
    return _transformations.keys.toList();
  }

  @override
  Future<bool> removeTransformation(String transformationName, Version<Transformation> transformationVersion) async
  {
    if(_transformations.containsKey(transformationName) == false)return false;
    return _transformations[transformationName]!.remove(transformationVersion) != null;
  }

  @override
  Future<bool> removeAllTransformationVersions(String transformationName) async
  {
    if(_transformations.containsKey(transformationName) == false)return false;
    return _transformations.remove(transformationName) != null;
  }
}
