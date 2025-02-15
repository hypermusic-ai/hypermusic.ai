import 'package:flutter/foundation.dart';

// Models
import '../model/running_instance.dart';

class RunningInstanceEditorController extends ValueNotifier<RunningInstance>
{
  RunningInstanceEditorController() : super(
    RunningInstance(
      startPoint: 0,
      howManyValues: 0,
      transformationStartIndex: 0,
      transformationSkipCount: 0,
    )
  );
}