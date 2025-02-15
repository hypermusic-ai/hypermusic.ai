import 'package:flutter/foundation.dart';

// Models
import '../model/transformation.dart';

class TransformationEditorController extends ValueNotifier<Transformation>
{
  List<int> args = [];

  TransformationEditorController({Transformation? transformation}) 
  : super( transformation ?? 
      Transformation(
        name: "default",
        function: (x, args) => x,
      )
  );

  void setArgs(List<int> args)
  {
    this.args = args;
    notifyListeners();
  }
}