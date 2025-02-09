import 'package:flutter/material.dart';
import 'package:hypermusic/controller/feature_editor_controller.dart';

//Views
import '../pt_editor.dart';
import 'pt_tree_editor_node.dart';


class PTTreeEditor extends PTEditorBase {
  const PTTreeEditor({super.key, required super.registry});

  @override
  State<PTTreeEditor> createState() => _PTTreeEditorState();
}

class _PTTreeEditorState extends State<PTTreeEditor> {

  FeatureEditorController rootFeatureController = FeatureEditorController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    rootFeatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
                Row(
                    children: [
                      Expanded(child: 
                        PTTreeEditorNode(registry : widget.registry, featureController: rootFeatureController,),
                      )
                    ],
                  )
          ],
        ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
