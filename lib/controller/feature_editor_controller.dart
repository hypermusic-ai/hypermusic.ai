import 'package:flutter/foundation.dart';

// Models
import 'package:hypermusic/model/feature.dart';

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

  void removeComposite(Feature feature)
  {
    value.composites.remove(feature);
    notifyListeners();
  }
  
  void addComposite(Feature feature)
  {
    value.composites.add(feature);
    notifyListeners();
  }

  void addTransformation(Feature feature, TransformFunctionDef transformation)
  {
    if(value.transformationsMap[feature.name] == null)
    {
      value.transformationsMap[feature.name] = [];
    }
    value.transformationsMap[feature.name]!.add(transformation);
    notifyListeners();
  }

  void removeTransformation(Feature feature, TransformFunctionDef transformation)
  {
    if(value.transformationsMap[feature.name] == null)return;

    value.transformationsMap[feature.name]!.remove(transformation);
    notifyListeners();
  }
}