// Models
import '../model/version.dart';
import '../model/feature.dart';
import '../model/running_instance.dart';
import '../model/transformation.dart';
import '../model/condition.dart';

/// defines a set of methods for managing data related to features, running instances, conditions, and transformations.
abstract class DataInterface
{
  /// will return registered feature version if registration sucessfull
  Future<Version<Feature>?> registerFeature(Feature feature);
  /// will return version if feature found
  Future<Version<Feature>?> containsFeature(Feature feature);
  /// will return feature with specyfic version
  Future<Feature?> getFeature(String featureName, Version<Feature> featureVersion);
  /// will return all feature names
  Future<List<String>> getAllFeatureNames();
  /// will return newest feature version
  Future<Feature?> getNewestFeature(String featureName);
  ///will return all feature versions for given name
  Future<List<Feature>> getAllFeatures(String featureName);
  /// will return all feature versions
  Future<List<Version<Feature>>> getAllFeatureVersions(String featureName);
  /// will remove feature with specyfic version
  Future<bool> removeFeature(String featureName, Version<Feature> featureVersion);
  ///will remove all feature versions for given name
  Future<bool> removeAllFeatureVersions(String featureName);

  /// will return registered RunningInstance version if registration sucessfull
  Future<Version<RunningInstance>?> registerRunningInstance(RunningInstance instance);
  /// will return RunningInstance with specyfic version
  Future<RunningInstance?> getRunningInstance(Version<RunningInstance> riVersion);
  /// will remove RunningInstance with specyfic version
  Future<bool> removeRunningInstance(Version<RunningInstance> riVersion);

  /// will return registered Condition version if registration sucessfull
  Future<Version<Condition>?> registerCondition(Condition condition);
  /// will return Condition with specyfic version
  Future<Condition?> getCondition(String conditionName, Version<Condition> conditionVersion);
  /// will return all conditions names
  Future<List<String>> getAllConditionsNames();
  /// will return newest Condition version
  Future<Condition?> getNewestCondition(String conditionName);
  ///will return all Conditions
  Future<List<Condition>> getAllConditions(String conditionName);
  /// will return all Condition versions
  Future<List<Version<Condition>>> getAllConditionVersions(String conditionName);
  /// will remove specyfic Condition version
  Future<bool> removeCondition(String conditionName, Version<Condition> conditionVersion);
  ///will remove all Condition versions
  Future<bool> removeAllConditionVersions(String conditionName);

  /// will return registered Transformation version if registration sucessfull
  Future<Version<Transformation>?> registerTransformation(Transformation transformation);
  /// will return Transformation with specyfic version
  Future<Transformation?> getTransformation(String transformationName, Version<Transformation> transformationVersion);
  /// will return all transformations names
  Future<List<String>> getAllTransformationsNames();
  /// will return newest Transformation version
  Future<Transformation?> getNewestTransformation(String transformationName);
  ///will return all Transformations
  Future<List<Transformation>> getAllTransformations(String transformationName);
  /// will return all Condition versions
  Future<List<Version<Transformation>>> getAllTransformationVersions(String transformationName);
  /// will remove specyfic Transformation version
  Future<bool> removeTransformation(String transformationName, Version<Transformation> transformationVersion);
  ///will remove all Transformation versions
  Future<bool> removeAllTransformationVersions(String transformationName);
}
