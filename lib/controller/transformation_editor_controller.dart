import 'package:flutter/foundation.dart';

// Models
import '../model/transformation.dart';

class TransformationEditorController extends ValueNotifier<Transformation>
{
  TransformationEditorController({Transformation? transformation}) 
  : super( transformation ?? 
  Transformation(
      name: "",
      args: [],
    )
  );
}