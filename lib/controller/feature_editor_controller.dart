import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Models
import '../model/feature.dart';
import '../model/transformation.dart';

class FeatureEditorController extends ValueNotifier<Feature>
{
 FeatureEditorController({Feature? feature})
    : super(feature ?? Feature(
          name: "Root",
          description: "Root feature for composition",
          composites: [],
          transformationsMap: {},
    ));

  void updateFeature(Feature newFeature) {
    value = newFeature;
    notifyListeners();
  }

  void addTransformation(Feature feature, Transformation transformation)
  {
    if(value.transformationsMap[feature] == null)
    {
      value.transformationsMap[feature] = [];
    }
    value.transformationsMap[feature]!.add(transformation);
    notifyListeners();
  }

  void removeTransformation(Feature feature, Transformation transformation)
  {
    if(value.transformationsMap[feature] == null)return;

    value.transformationsMap[feature]!.remove(transformation);
    notifyListeners();
  }
}