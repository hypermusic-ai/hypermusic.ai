import 'package:flutter/material.dart';

//View

//Controllers
import '../../../controller/data_interface.dart';
import '../../../controller/feature_editor_controller.dart';

abstract class PTEditorNodeBase extends StatefulWidget
{
  final DataInterface registry;
  final FeatureEditorController featureController;

  PTEditorNodeBase({
    super.key,
    required this.registry,
    required this.featureController
  });

}