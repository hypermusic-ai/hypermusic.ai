import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// Models
import '../model/feature.dart';
import '../model/transformation.dart';

// Controllers
import 'transformation_editor_controller.dart';

class FeatureEditorController extends ValueNotifier<Feature>
{
  FeatureEditorController? parent;
  List<FeatureEditorController> compositesControllers = [];
  Map<Feature, List<TransformationEditorController>> transformationControllers = {};

  FeatureEditorController({Feature? feature, this.parent})
    : super(feature ?? Feature(
          name: "Root",
          description: "Root feature for composition",
          composites: [],
          transformationsMap: {},
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
  }

  void _initSubcontrollers()
  {
    _disposeSubcontrollers();

    for(Feature composite in value.composites)
    {
      FeatureEditorController compositeController = FeatureEditorController(feature: composite, parent: this);
      compositesControllers.add(compositeController);
      
      transformationControllers[composite] ??= [];
      for(Transformation transformation in value.transformationsMap[composite] ?? [])
      {
        transformationControllers[composite]!.add(TransformationEditorController(transformation: transformation));
        transformationControllers[composite]!.last.addListener(notifyListeners);
      }
    }
  }

  void _sync()
  {
    developer.log("${value.name}  sync with composites", name: 'hypermusic.app.feature_editor_controller');
    value.composites.clear();
    for(FeatureEditorController compositeController in compositesControllers)
    {
      value.composites.add(compositeController.value);
      
      value.transformationsMap[compositeController.value] ??= [];
      value.transformationsMap[compositeController.value]!.clear();
      for(TransformationEditorController transformationController in transformationControllers[compositeController.value] ?? [])
      {
        value.transformationsMap[compositeController.value]!.add(transformationController.value);
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
          transformationsMap: {},
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
    value.transformationsMap[feature] ??= [];
    value.transformationsMap[feature]!.add(transformation);
    
    transformationControllers[feature] ??= [];
    transformationControllers[feature]!.add(TransformationEditorController(transformation: transformation));

    notifyListeners();
  }

  void removeTransformation(Feature feature, Transformation transformation)
  {    
    value.transformationsMap[feature] ??= [];
    int transformationsMapIdx = -1;
    if((transformationsMapIdx = value.transformationsMap[feature]!.indexWhere((element) => element == transformation)) != -1){
      value.transformationsMap[feature]!.removeAt(transformationsMapIdx);
    }

    transformationControllers[feature] ??= [];
    int transformationsContrllersIdx = -1;
    if((transformationsContrllersIdx = transformationControllers[feature]!.indexWhere((element) => element.value == transformation)) != -1){
      transformationControllers[feature]!.removeAt(transformationsContrllersIdx);
    }

    notifyListeners();
  }
}