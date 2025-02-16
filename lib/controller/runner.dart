// Models
import '../model/version.dart';
import '../model/feature.dart';
import '../model/running_instance.dart';

// Controllers
import 'data_interface.dart';

class SampleSource
{
  final List<Feature> feature;

  SampleSource(this.feature);
}

class Runner {
  final DataInterface registry;

  Runner({required this.registry});

  Future<List<List<int>>> gen(String featureName, Version<RunningInstance> runningInstanceVersion, {List<dynamic> conditionArgs = const []}) async 
  {
    final feature = await registry.getNewestFeature(featureName);
    if (feature == null) {
      throw Exception('Feature $featureName not found');
    }

    final runningInstance = await registry.getRunningInstance(runningInstanceVersion);
    if (runningInstance == null) {
      throw Exception('RunningInstance $runningInstanceVersion not found');
    }

    if (!feature.checkCondition(conditionArgs)) {
      throw Exception('Feature condition not met');
    }

    final N = runningInstance.howManyValues ?? 0;
    final numberOfScalars = feature.getScalarsCount();
    final samplesBuffer = List<List<int>>.generate(
      numberOfScalars,
      (_) => List<int>.filled(N, 0),
    );

    

    final indexes = List<int>.generate(
        N, (i) => i + (runningInstance.startPoint ?? 0));
    _decompose(feature, [(runningInstance.startPoint ?? 0)], 1, indexes, 0, samplesBuffer);

    return samplesBuffer;
  }

  void _decompose(
    Feature feature,
    List<int> startingPoints,
    int startPointId,
    List<int> indexes,
    int dest,
    List<List<int>> outBuffer,
    {List<dynamic> conditionArgs = const []}
  ) {
    if (dest >= outBuffer.length) {
      throw Exception('Buffer too small');
    }

    if (!feature.checkCondition(conditionArgs)) {
      throw Exception('Feature condition not met');
    }

    if (feature.isScalar()) {
      for (var i = 0; i < outBuffer[dest].length; i++) {
        outBuffer[dest][i] = indexes[i];
      }
      return;
    }

    var start = 0;
    List<int> compositeIndexes;

    for (var dimId = 0; dimId < feature.composites.length; dimId++) {
      if (startPointId < startingPoints.length) {
        start = startingPoints[startPointId];
      }

      compositeIndexes = _genSubfeatureIndexes(feature, dimId, start, indexes);

      final subfeature = feature.composites[dimId];
      _decompose(subfeature, startingPoints, startPointId, compositeIndexes,
          dest, outBuffer);

      dest += subfeature.getScalarsCount();
      startPointId += subfeature.getSubTreeSize() + 1;
    }
  }

  List<int> _genSubfeatureIndexes(
      Feature feature, int dimId, int start, List<int> samplesIndexes) {
    final subspace = _generateSubfeatureSpace(
        feature, dimId, start, _findMaxIndex(samplesIndexes) + 1);
    return samplesIndexes.map((i) => subspace[i]).toList();
  }

  List<int> _generateSubfeatureSpace(
      Feature feature, int dimId, int start, int N) {
    if (dimId < 0 || dimId >= feature.composites.length) {
      throw Exception('Invalid dimension id');
    }

    final space = List<int>.filled(N, 0);
    var x = start;
    for (var opId = 0; opId < N; opId++) {
      space[opId] = x;
      x = feature.transform(dimId, opId, x);
    }

    return space;
  }

  int _findMaxIndex(List<int> indexes) {
    var max = 0;
    for (final index in indexes) {
      if (index > max) max = index;
    }
    return max;
  }
}
