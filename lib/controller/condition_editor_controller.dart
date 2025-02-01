import 'package:flutter/foundation.dart';

// Models
import 'package:hypermusic/model/condition.dart';

class ConditionEditorController extends ValueNotifier<Condition>
{
  ConditionEditorController() : super(
    Condition(
      name: "",
      description: "",
    )
  );
}