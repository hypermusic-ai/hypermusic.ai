import 'package:tuple/tuple.dart';

import 'model/transformation.dart';
import 'model/feature.dart';
import 'model/running_instance.dart';
import 'model/condition.dart';

import 'controller/data_interface.dart';

class RegistryInitializer {
  static Future<bool> initialize(DataInterface registry) async
  {
    // ------------------------
    // Register basic transformations

    final addTransformationVer = await registry.registerTransformation( 
      Transformation(
        name:'Add',
        description: "Adds a constant to the input index",
        function: (x, args) => x + args[0],
        argsCount: 1
      )
    );
    if(addTransformationVer == null){
      assert(false, "Failed to register Add Transformation");
      return false;
    }

    final mulTransformationVer = await registry.registerTransformation( 
      Transformation(
        name:'Mul',
        description: "Multiplies the input index by a constant",
        function: (x, args) => x * args[0],
        argsCount: 1
      )
    );
    if(mulTransformationVer == null){
      assert(false, "Failed to register Mul Transformation");
      return false;
    }

    final nopTransformationVer = await registry.registerTransformation(
      Transformation(
        name:'Nop',
        description: "No operation",
        function: (x, args) => x,
        argsCount: 0
      )
    );
    if(nopTransformationVer == null){
      assert(false, "Failed to register Nop Transformation");
      return false;
    }

    // ------------------------
    // Register basic conditions

    final trueConditionVer = await registry.registerCondition(
      Condition(
        name: "True",
        description: "",
        checkFunction: (List<dynamic> args) => true
      )
    );
    if(trueConditionVer == null){
      assert(false, "Failed to register True Condition");
      return false;
    }

    // Register running instances
    registry.registerRunningInstance( 
    RunningInstance(
      startPoint: 60,
      howManyValues: 12,
      transformationStartIndex: 0,
      transformationSkipCount: 0,
    ));
    registry.registerRunningInstance( 
      RunningInstance(
        startPoint: 60,
        howManyValues: 12,
        transformationStartIndex: 0,
        transformationSkipCount: 0,
    ));
    registry.registerRunningInstance( 
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationSkipCount: 0,
    ));
    registry.registerRunningInstance(
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationSkipCount: 5,
    ));
    registry.registerRunningInstance(
      RunningInstance(
        startPoint: 0,
        howManyValues: 8,
        transformationStartIndex: 0,
        transformationSkipCount: 0,
    ));

    // ------------------------
    // Register scalar features

    // Register Pitch
    final pitchVer = await registry.registerFeature(
      Feature(
        name: "Pitch",
        description: "A scalar feature representing pitch",
        composites: [],
        transformationDefs: {},
        condition: null,
        runningInstances: {},
    ));
    if(pitchVer == null){
      assert(false, "Failed to register Pitch feature");
      return false;
    }

    // Register Time
    final timeVer = await registry.registerFeature(
      Feature(
        name: "Time",
        description: "A scalar feature representing time",
        composites: [],
        transformationDefs: {},
        condition: null,
        runningInstances: {},
    ));
    if(timeVer == null){
      assert(false, "Failed to register Time feature");
      return false;
    }

    // Register Duration
    final durationVer = await registry.registerFeature(
      Feature(
        name: "Duration",
        description: "A scalar feature representing duration",
        composites: [],
        transformationDefs: {},
        condition: null,
        runningInstances: {},
    ));
    if(durationVer == null){
      assert(false, "Failed to register Duration feature");
      return false;
    }

    // Register composite features

    // Register FeatureA
    final featureAVer = await registry.registerFeature(
      Feature(
        name: "FeatureA",
        description: "A composite feature combining Pitch and Time",
        composites: [
            (await registry.getFeature("Pitch", pitchVer))!,
            (await registry.getFeature("Time", timeVer))!,
        ],
        transformationDefs: {
          (await registry.getFeature("Pitch", pitchVer))!: [
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [1]),
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [2]),
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [3]),
          ],
          (await registry.getFeature("Time", timeVer))!: [
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [1]),
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [2]),
            TransformationDef(transformation : (await registry.getTransformation("Nop", nopTransformationVer))!, args : []),
          ],
        },
        condition: null,
        runningInstances: {},
    ));
    if(featureAVer == null){
      assert(false, "Failed to register FeatureA feature");
      return false;
    }

    // Register FeatureB
    final featureBVer = await registry.registerFeature(
      Feature(
        name: "FeatureB",
        description: "A composite feature combining Duration and FeatureA",
        composites: [
            (await registry.getFeature("Duration", durationVer))!, 
            (await registry.getFeature("FeatureA", featureAVer))!,
        ],
        transformationDefs: {
          (await registry.getFeature("Duration", durationVer))!: [
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [1]),
            TransformationDef(transformation : (await registry.getTransformation("Mul", mulTransformationVer))!, args : [3]),
            TransformationDef(transformation : (await registry.getTransformation("Nop", nopTransformationVer))!, args : []),
          ],
          (await registry.getFeature("FeatureA", featureAVer))!: [
            TransformationDef(transformation : (await registry.getTransformation("Add", addTransformationVer))!, args : [5]),
            TransformationDef(transformation : (await registry.getTransformation("Nop", nopTransformationVer))!, args : []),
            TransformationDef(transformation : (await registry.getTransformation("Mul", mulTransformationVer))!, args : [7]),
          ],
        },
        condition: null,
        runningInstances: {},
    ));
    if(featureBVer == null){
      assert(false, "Failed to register FeatureB feature");
      return false;
    }

    return true;
  }
}
