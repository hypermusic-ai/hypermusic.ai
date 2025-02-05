import 'package:flutter/material.dart';

// Controllers
import '../../../../controller/feature_editor_controller.dart';

class FeatureDetailsEditor extends StatefulWidget {

  final FeatureEditorController featureEditorController;

  const FeatureDetailsEditor({super.key, required this.featureEditorController,});

  @override
  State<FeatureDetailsEditor> createState() => _FeatureEditorEditorState();
}

class _FeatureEditorEditorState extends State<FeatureDetailsEditor> {

  late TextEditingController _descriptionController;

  @override
  void initState() {
    
    super.initState();
    
    widget.featureEditorController.addListener(_onFeatureChanged);

    _fetchControllerData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged(String value) {

    if (widget.featureEditorController.value.description == _descriptionController.text)return;
    widget.featureEditorController.updateFeature(widget.featureEditorController.value.copyWith(description: _descriptionController.text));
    setState(() {_fetchControllerData();});
  }

  void _onFeatureChanged() {
    setState(() {_fetchControllerData();});
  }

  void _fetchControllerData() {
    _descriptionController = TextEditingController(text: widget.featureEditorController.value.description.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Desc: '),
             SizedBox(width: 192,
              child: TextField(
                onSubmitted: (value) {_onDescriptionChanged(value);},
                style: const TextStyle(fontSize: 11),
                controller: _descriptionController,
                keyboardType: TextInputType.number,
                maxLines: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          // children: [
          //   const Text('Transformation Range: '),
          //   const SizedBox(width: 8),
          //   SizedBox(
          //     width: 100,
          //     child: TextField(
          //       controller: _transformationStartIndexController,
          //       keyboardType: TextInputType.number,
          //     ),
          //   ),
          //   const Text(' to '),
          //   SizedBox(
          //     width: 100,
          //     child: TextField(
          //       controller: _transformationEndIndexController,
          //       keyboardType: TextInputType.number,
          //     ),
          //   ),
          // ],
        ),
      ],
    );
  }
}
