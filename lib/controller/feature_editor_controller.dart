import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:developer' as developer;

// Models
import '../model/feature.dart';
import '../model/transformation.dart';

// Controllers
import 'transformation_editor_controller.dart';
import 'condition_editor_controller.dart';
import 'running_instance_editor_controller.dart';

// TODO
// class EditorNode{
//   Feature feature;
//   Map<Feature, List<Transformation>>  
//   EditorNode({required this.feature});
// }

class FeatureEditorController extends ValueNotifier<Feature>
{
  FeatureEditorController? parent;
  List<FeatureEditorController> compositesControllers = [];
  Map<Feature, List<TransformationEditorController>> transformationControllers = {};
  ConditionEditorController conditionController;
  RunningInstanceEditorController runningInstanceController;

  FeatureEditorController({Feature? feature, this.parent})
    : conditionController = ConditionEditorController(),
      runningInstanceController = RunningInstanceEditorController(),
      super(feature ?? Feature(
          name: "Root",
          description: "Root feature for composition",
          composites: [],
          transformations: {},
          runningInstances: {},
          condition: null,
    ))
    {
      _initSubcontrollers();
    }

  @override
  void notifyListeners() {
    developer.log("${value.name} notifyListeners", name: 'hypermusic.app.feature_editor_controller');
    super.notifyListeners();
    parent?.notifyListeners();
  }

  @override
  void dispose() {
    developer.log("${value.name} dispose", name: 'hypermusic.app.feature_editor_controller');
    _disposeSubcontrollers();
    super.dispose();
  }

  void _disposeSubcontrollers()
  {
    for(FeatureEditorController compositeController in compositesControllers)
    {
      compositeController.dispose();

      for(TransformationEditorController transformationController in transformationControllers[compositeController.value] ?? [])
      {
        transformationController.dispose();
      }
      transformationControllers[compositeController.value]?.clear();
    }
    transformationControllers.clear();
    compositesControllers.clear();

    conditionController.dispose();
    runningInstanceController.dispose();
  }

  void _initSubcontrollers()
  {
    _disposeSubcontrollers();

    for(Feature composite in value.composites)
    {
      FeatureEditorController compositeController = FeatureEditorController(feature: composite, parent: this);
      compositesControllers.add(compositeController);
      
      transformationControllers[composite] ??= [];
      for(Tuple2<Transformation, List<int>> transformationDef in value.transformations[composite] ?? [])
      {
        transformationControllers[composite]!.add(TransformationEditorController(transformation: transformationDef.item1));
        transformationControllers[composite]!.last.setArgs(transformationDef.item2);
        transformationControllers[composite]!.last.addListener(notifyListeners);
      }
    }

    conditionController = ConditionEditorController();
    runningInstanceController = RunningInstanceEditorController();
  }

  void _sync()
  {
    developer.log("${value.name}  sync with composites", name: 'hypermusic.app.feature_editor_controller');
    value.composites.clear();
    for(FeatureEditorController compositeController in compositesControllers)
    {
      value.composites.add(compositeController.value);
      
      value.transformations[compositeController.value] ??= [];
      value.transformations[compositeController.value]!.clear();
      for(TransformationEditorController transformationController in transformationControllers[compositeController.value] ?? [])
      {
        value.transformations[compositeController.value]!.add(
          Tuple2(transformationController.value, transformationController.args)
        );
      }
    }
    if(parent != null) parent!._sync();
  }

  void updateFeature(Feature? newFeature) {
    developer.log("${newFeature?.name} updateFeature with parent ${parent?.value.name}", name: 'hypermusic.app.feature_editor_controller');

    value = newFeature ?? Feature(
          name: "Root",
          description: "Root feature for composition",
          composites: [],
          transformations: {},
          runningInstances: {},
          condition: null,
    );
    _initSubcontrollers();
    _sync();
    notifyListeners();
  }

  void updateName(String name)
  {
    value.name = name;
    notifyListeners();
  }

  void addComposite(Feature composite) 
  {
    value.composites.add(composite);
    compositesControllers.add(FeatureEditorController(feature: composite, parent: this));
    notifyListeners();
  }

  void removeComposite(Feature composite) 
  {
    int compositesIdx = -1;
    if((compositesIdx = value.composites.indexWhere((element) => element == composite)) != -1){
      value.composites.removeAt(compositesIdx);
    }
    
    int compositesControllersIdx = -1;
    if((compositesControllersIdx = compositesControllers.indexWhere((element) => element.value == composite)) != -1){
      compositesControllers.removeAt(compositesControllersIdx);
    }
    notifyListeners();
  }

  void addTransformation(Feature feature, Transformation transformation)
  {
    value.transformations[feature] ??= [];
    value.transformations[feature]!.add(Tuple2(transformation, []));
    
    transformationControllers[feature] ??= [];
    transformationControllers[feature]!.add(TransformationEditorController(transformation: transformation));

    notifyListeners();
  }

  void removeTransformation(Feature feature, Transformation transformation)
  {    
    value.transformations[feature] ??= [];
    int transformationsIdx = -1;
    if((transformationsIdx = value.transformations[feature]!.indexWhere((element) => element == transformation)) != -1){
      value.transformations[feature]!.removeAt(transformationsIdx);
    }

    transformationControllers[feature] ??= [];
    int transformationsContrllersIdx = -1;
    if((transformationsContrllersIdx = transformationControllers[feature]!.indexWhere((element) => element.value == transformation)) != -1){
      transformationControllers[feature]!.removeAt(transformationsContrllersIdx);
    }

    notifyListeners();
  }
}