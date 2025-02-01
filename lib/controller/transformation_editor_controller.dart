import 'package:flutter/foundation.dart';

// Models
import 'package:hypermusic/model/transformation.dart';

class TransformationEditorController extends ValueNotifier<Transformation>
{
  TransformationEditorController() : super(
    Transformation(
      name: "",
      args: [],
    )
  );
}