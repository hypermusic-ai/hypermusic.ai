import 'package:flutter/foundation.dart';

// Models
import '../model/condition.dart';

class ConditionEditorController extends ValueNotifier<Condition>
{
  ConditionEditorController() : super(
    Condition(
      name: "",
      description: "",
      checkFunction: (args) => true
    )
  );
}