import 'package:flutter/foundation.dart';

// Models
import '../model/transformation.dart';

class TransformationEditorController extends ValueNotifier<TransformationDef>
{
  TransformationEditorController({TransformationDef? transformationDef}) 
  : super( transformationDef ?? 
      TransformationDef(
        transformation: Transformation(name: "default", function: (x, args) => x),
        args: [],
      )
  );


  void setArgs(List<int> args)
  {
    value.args = args;
    notifyListeners();
  }
}