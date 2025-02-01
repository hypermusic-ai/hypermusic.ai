import 'model/feature.dart';
import 'package:tuple/tuple.dart';

import 'model/running_instance.dart';
import 'package:hypermusic/controller/data_interface_controller.dart';

class RegistryInitializer {
  static Future<bool> initialize(DataInterfaceController registry) async
  {
    // Register scalar features

    // Register Pitch
    final pitchVer = await registry.registerFeature(
      Feature(
        name: "Pitch",
        description: "A scalar feature representing pitch",
        composites: [],
        transformationsMap: {},
    ));
    if(pitchVer == null){
      assert(false, "Failed to register Pitch feature");
      return false;
    }
    // Register Pitch running instance
    registry.registerRunningInstance('Pitch', pitchVer, 
      RunningInstance(
        startPoint: 60,
        howManyValues: 12,
        transformationStartIndex: 0,
        transformationEndIndex: 0,
    ));

    // Register Time
    final timeVer = await registry.registerFeature(
      Feature(
        name: "Time",
        description: "A scalar feature representing time",
        composites: [],
        transformationsMap: {},
    ));
    if(timeVer == null){
      assert(false, "Failed to register Time feature");
      return false;
    }
    // Register Time running instance
    registry.registerRunningInstance('Time', timeVer, 
    RunningInstance(
      startPoint: 60,
      howManyValues: 12,
      transformationStartIndex: 0,
      transformationEndIndex: 0,
    ));

    // Register Duration
    final durationVer = await registry.registerFeature(
      Feature(
        name: "Duration",
        description: "A scalar feature representing duration",
        composites: [],
        transformationsMap: {},
    ));
    if(durationVer == null){
      assert(false, "Failed to register Duration feature");
      return false;
    }
    // Register Duration running instance
    registry.registerRunningInstance('Duration', durationVer, 
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationEndIndex: 0,
    ));

    // Register composite features

    // Register FeatureA
    final featureAVer = await registry.registerFeature(
      Feature(
        name: "FeatureA",
        description: "A composite feature combining Pitch and Time",
        composites: [
            registry.getFeature("Pitch", pitchVer)!,
            registry.getFeature("Time", timeVer)!,
        ],
        transformationsMap: {
          'Pitch': [
            Tuple2('Add', [1]),
            Tuple2('Add', [2]),            
            Tuple2('Add', [3]),
          ],
          'Time': [
            Tuple2('Add', [1]),
            Tuple2('Add', [2]),
            Tuple2('Nop', [])

          ],
        },
    ));
    if(featureAVer == null){
      assert(false, "Failed to register FeatureA feature");
      return false;
    }
    // Register FeatureA running instance
    registry.registerRunningInstance('FeatureA', featureAVer,
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationEndIndex: 5,
    ));

    // Register FeatureB
    final featureBVer = await registry.registerFeature(
      Feature(
        name: "FeatureB",
        description: "A composite feature combining Duration and FeatureA",
        composites: [
            registry.getFeature("Duration", durationVer)!, 
            registry.getFeature("FeatureA", featureAVer)!,
        ],
        transformationsMap: {
          'Duration': [
            Tuple2('Add', [5]),
            Tuple2('Mul', [2]),            
            Tuple2('Nop', []),
          ],
          'FeatureA': [
            Tuple2('Add', [5]),
            Tuple2('Nop', []),            
            Tuple2('Mul', [7]),            
          ],
        },
    ));
    if(featureBVer == null){
      assert(false, "Failed to register FeatureB feature");
      return false;
    }
    // Register FeatureB running instance
    registry.registerRunningInstance('FeatureB', featureBVer,
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationEndIndex: 0,
    ));
    return true;
  }
}
