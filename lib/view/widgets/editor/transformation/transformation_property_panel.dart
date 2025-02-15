import 'package:flutter/material.dart';

//Model
import '../../../../model/transformation.dart';

//Controllers
import '../../../../controller/transformation_editor_controller.dart';

class TransformationPropertyPanel extends StatefulWidget {

  final TransformationEditorController transformationController;

  const TransformationPropertyPanel({
    super.key,
    required this.transformationController,
  });

  @override
  State<TransformationPropertyPanel> createState() =>
      _TransformationPropertyPanelState();

  Transformation  get transformation => transformationController.value.transformation;
  List<int>       get args => transformationController.value.args;
}

class _TransformationPropertyPanelState
    extends State<TransformationPropertyPanel> {
  late TextEditingController _argController;

  @override
  void initState() {
    super.initState();
    // Assume the first arg is an integer
    final arg = widget.args.isNotEmpty
        ? widget.args[0]
        : 0;
    _argController = TextEditingController(text: arg.toString());
  }

  @override
  void dispose()
  {
    _argController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // A Material widget for elevation and styling
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit ${widget.transformation.name}'),
            const SizedBox(height: 8),
            // Text field to edit the first argument
            TextField(
              controller: _argController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Argument',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
