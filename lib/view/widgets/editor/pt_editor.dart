import 'package:flutter/material.dart';

// Controllers
import '../../../controller/data_interface.dart';

abstract class PTEditorBase extends StatefulWidget {
  final DataInterface registry;

  const PTEditorBase({super.key, required this.registry});
}