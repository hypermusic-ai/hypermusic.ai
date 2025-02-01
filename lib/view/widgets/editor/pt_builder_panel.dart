import 'package:flutter/material.dart';

// Views
import 'package:hypermusic/view/widgets/editor/pt_editor.dart';

//Controllers
import 'package:hypermusic/controller/data_interface_controller.dart';
import 'package:hypermusic/controller/feature_editor_controller.dart';


class FeatureBuilderPanel extends StatefulWidget {

  final DataInterfaceController dataInterfaceController;
  final FeatureEditorController featureEditorController;

  const FeatureBuilderPanel({
    super.key,
    required this.dataInterfaceController,
    required this.featureEditorController,
  });

  @override
  State<FeatureBuilderPanel> createState() => _FeatureBuilderPanelState();
}

class _FeatureBuilderPanelState extends State<FeatureBuilderPanel> {

  bool _isBuilding = false;

  void _handleBuild() async {
    if (widget.featureEditorController.value.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for the feature'),
        ),
      );
      return;
    }

    setState(() {
      _isBuilding = true;
    });

    try {

      // // Get all running instances from the tree
      // final runningInstances = _treeEditorKey.currentState
      //         ?.collectRunningInstances(rootFeature, []) ??
      //     [];

      // // Register the feature with its running instances
      // await widget.registry.registerFeature(
      //   _nameController.text,
      //   rootFeature.composites
      //       .map((f) => f.name.split('_').first)
      //       .toList(), // Use original names
      //   rootFeature.transformationsMap.entries.expand((entry) {
      //     return entry.value.map((t) => {
      //           'subFeatureName': entry.key,
      //           ...t,
      //         });
      //   }).toList(),
      //   runningInstances: runningInstances, // Pass running instances
      // );

      // widget.onFeatureStructureUpdated(rootFeature);
      // widget.onFeatureCompiled();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feature built successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error building feature: ${e.toString()}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBuilding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const SizedBox(width: 4),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: _isBuilding ? null : _handleBuild,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                  child: _isBuilding
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Build'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: PTEditor()  
        ),
      ],
    );
  }
}
