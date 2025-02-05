import 'package:flutter/material.dart';

// Models
import '../../../model/feature.dart';

//Controllers
import '../../../controller/data_interface.dart';
import '../../../controller/feature_editor_controller.dart';

abstract class PTEditorNodeBase extends StatefulWidget
{
  final DataInterface _registry;
  final FeatureEditorController _featureController;
  final ValueNotifier<bool> _highlightedController = ValueNotifier<bool>(false);

  final VoidCallback? onUpdated;

  final List<PTEditorNodeBase> _childreen = [];

  PTEditorNodeBase({
    super.key,
    required DataInterface registry,
    FeatureEditorController? featureController,
    this.onUpdated
  })
  : _registry = registry, 
    _featureController = featureController ?? FeatureEditorController();

  DataInterface           get registry => _registry;
  FeatureEditorController get featureController => _featureController;
  ValueNotifier<bool>     get highlightedController => _highlightedController;

  Feature   get feature => _featureController.value;
  bool      get isHighlighted => _highlightedController.value;


  void addChild(PTEditorNodeBase child)
  { 
    _childreen.add(child);
  }

  void removeChild(PTEditorNodeBase child)
  { 
    _childreen.removeAt(_childreen.indexWhere((element) => element == child));
  }
}