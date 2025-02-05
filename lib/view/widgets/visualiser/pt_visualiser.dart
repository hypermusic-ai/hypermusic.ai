import 'package:flutter/material.dart';

//Views
import '../editor/pt_editor.dart';

abstract class PTVisualiserBase extends StatefulWidget {

  final PTEditorBase? editor;

  const PTVisualiserBase({super.key, this.editor});
}