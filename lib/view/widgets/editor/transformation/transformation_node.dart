import 'package:flutter/material.dart';

// Models
import '../../../../model/transformation.dart'; // todo 

//Controllers
import '../../../../controller/transformation_editor_controller.dart';

class TransformationNode extends StatefulWidget {
  final TransformationEditorController _transformationController;

  TransformationNode({
    super.key,
    TransformationEditorController? transformationController,
  }) 
  : _transformationController = transformationController ?? TransformationEditorController();

  @override
  State<TransformationNode> createState() => _TransformationNodeState();

  TransformationEditorController get transformationController => _transformationController;
  Transformation   get transformation => _transformationController.value;
}

class _TransformationNodeState extends State<TransformationNode> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getTransformationDescription() {
    switch (widget.transformation.name) {
      case "Add":
        return "Add ${widget.transformation.args.isNotEmpty ? widget.transformation.args[0] : 0} to index";
      case "Mul":
        return "Multiply index by ${widget.transformation.args.isNotEmpty ? widget.transformation.args[0] : 1}";
      case "Nop":
        return "No operation (pass through)";
      default:
        return "Unknown transformation";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.transformation.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _getTransformationDescription(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
