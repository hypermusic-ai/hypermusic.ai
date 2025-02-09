import 'package:flutter/material.dart';

// Models
import '../../../../model/transformation.dart'; // todo 

//Controllers
import '../../../../controller/transformation_editor_controller.dart';

class TransformationNode extends StatefulWidget {
  final TransformationEditorController transformationController;

  TransformationNode({
    super.key,
    required this.transformationController,
  });

  @override
  State<TransformationNode> createState() => _TransformationNodeState();

  Transformation   get transformation => transformationController.value;
}

class _TransformationNodeState extends State<TransformationNode> {

  final TextEditingController _argsController = TextEditingController();

  @override
  void initState() {
    _argsController.text = widget.transformation.args.isNotEmpty ? widget.transformation.args[0].toString() : '';
    
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
  void _onArgsChanged(String value)
  {
    List<int> args = [];
    
    int? arg0 = int.tryParse(value);
    if(arg0 != null) args.add(arg0);

    widget.transformationController.setArgs(args);
    setState(() {_argsController.text = value;});
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
                Row(
                  children:[
                    Text(
                      widget.transformation.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: TextField(
                    controller: _argsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 11),
                    onSubmitted: (value) {_onArgsChanged(value);},
                    decoration: const InputDecoration(
                      labelText: 'args',
                      labelStyle: TextStyle(fontSize: 11),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Keep vertical padding minimal
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                    )
                  )
                  ],
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
