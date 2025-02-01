import 'package:flutter/material.dart';

// Models
import 'package:hypermusic/model/feature.dart';
import 'package:hypermusic/model/transformation.dart';

// Views
import 'package:hypermusic/view/widgets/editor/running_instance/running_instance_editor.dart';
import 'package:hypermusic/view/widgets/editor/transformation/transformation_node.dart';
import 'package:hypermusic/view/widgets/editor/feature/feature_editor.dart';

//Controllers
import 'package:hypermusic/controller/feature_editor_controller.dart';
import 'package:hypermusic/controller/running_instance_editor_controller.dart';
import 'package:hypermusic/controller/condition_editor_controller.dart';
import 'package:hypermusic/controller/transformation_editor_controller.dart';

class PTEditorNode extends StatefulWidget {
  final FeatureEditorController featureEditorController;
  final RunningInstanceEditorController runningInstanceEditorController;
  final ConditionEditorController conditionEditorController;
  final Map<Feature, TransformationEditorController>
      transformationEditorControllers;

  PTEditorNode({
    super.key,
    Feature? feature,
  })  : runningInstanceEditorController = RunningInstanceEditorController(),
        featureEditorController = FeatureEditorController(feature: feature),
        conditionEditorController = ConditionEditorController(),
        transformationEditorControllers = {};

  @override
  State<PTEditorNode> createState() => _PTEditorNodeState();
}

class _PTEditorNodeState extends State<PTEditorNode> {
  bool _isExpanded = false;
  bool _showDetails = false;
  bool _showRunningInstance = false;

  bool _dirty = false;

  final TextEditingController _nameController = TextEditingController();

  List<Feature> _subNodes = [];

  @override
  void initState() {
    super.initState();

    _dirty = false;

    widget.featureEditorController.addListener(_onFeatureChanged);

    _fetchControllerData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onAcceptWithDetails(DragTargetDetails<Feature> details) {
    widget.featureEditorController.updateFeature(details.data.copyWith());
    setState(() {
      _dirty = false;
      _fetchControllerData();
    });
  }

  void _onFeatureChanged() {
    if (_nameController.text == widget.featureEditorController.value.name)return;
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _onTextChanged(String value) {
    if (widget.featureEditorController.value.name == _nameController.text)return;
    widget.featureEditorController.updateFeature(widget
        .featureEditorController.value
        .copyWith(name: _nameController.text));
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _onCompositeRemoved(Feature feature) {
    widget.featureEditorController.removeComposite(feature);
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _onCompositeAdded(DragTargetDetails<Feature> details) {
    widget.featureEditorController.addComposite(details.data);
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _onTransformationAdded(
      Feature feature, DragTargetDetails<Transformation> details) {
    widget.featureEditorController.addTransformation(
        feature, TransformFunctionDef(details.data.name, details.data.args));
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _onTransformationRemoved(Feature feature, TransformFunctionDef transformation) {
    widget.featureEditorController.removeTransformation(
        feature, transformation);
    setState(() {
      _dirty = true;
      _fetchControllerData();
    });
  }

  void _fetchControllerData() {
    _nameController.text = widget.featureEditorController.value.name;

    _subNodes.clear();
    for (var subFeature in widget.featureEditorController.value.composites) {
      _subNodes.add(subFeature);
    }
  }

  Widget _buildRunningInstance(BuildContext context) {
    return Container(
      child: RunningInstanceEditor(
        runningInstanceEditorController: widget.runningInstanceEditorController,
      ),
    );
  }

  Widget _buildDetals(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: FeatureEditor(
              featureEditorController: widget.featureEditorController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Column(children: [
      Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
            for (var subNode in _subNodes) ...[
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _dirty
                            ? Colors.red
                            : Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(
                        16), // Adjust value for more/less roundness
                  ),
                  child: Stack(children: [

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            Flexible(
                              flex: 1,
                              child: ListView.builder(
                                shrinkWrap:
                                    true, 
                                itemCount: widget
                                        .featureEditorController
                                        .value
                                        .transformationsMap[subNode.name]
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final transform = widget
                                      .featureEditorController
                                      .value
                                      .transformationsMap[subNode.name]![index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 16.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          color: Colors.red,
                                          iconSize: 16,
                                          onPressed: () => _onTransformationRemoved(subNode, transform),
                                        ),
                                        Expanded(
                                          child: TransformationNode(
                                            transformationName: transform.item1,
                                            args: transform.item2,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ]),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor)),
                            child: DragTarget<Transformation>(
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                    child: Container(
                                  height: 50,
                                  color: Colors.lightGreen,
                                  child: const Center(
                                      child: Text(
                                          "Drop here to add a transformation")),
                                ));
                              },
                              onAcceptWithDetails: (details) =>
                                  _onTransformationAdded(subNode, details),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 16.0),
                              child: PTEditorNode(feature: subNode.copyWith())),
                        ]),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 16,
                        onPressed: () => _onCompositeRemoved(subNode),
                      ),
                    ),
                  ]))
            ],
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor)),
              child: DragTarget<Feature>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                      child: Container(
                    height: 50,
                    color: Colors.lightGreen,
                    child:
                        const Center(child: Text("Drop here to add a feature")),
                  ));
                },
                onAcceptWithDetails: (details) => _onCompositeAdded(details),
              ),
            )
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _fetchControllerData();

    return Column(children: [
      Row(children: [
        Expanded(
          child: DragTarget<Feature>(
            builder: (context, candidateData, rejectedData) {
              return SizedBox(
                height: 28,
                width: 128,
                child: TextField(
                  controller: _nameController,
                  onSubmitted: (value) {
                    _onTextChanged(value);
                  },
                  style: const TextStyle(fontSize: 11),
                  decoration: InputDecoration(
                    labelText: 'Feature Name',
                    labelStyle: TextStyle(fontSize: 11),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                          color: _dirty
                              ? Colors.red
                              : Theme.of(context).dividerColor),
                    ),
                  ),
                ),
              );
            },
            onAcceptWithDetails: (details) => _onAcceptWithDetails(details),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                _isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 24,
              ),
              onPressed: () => setState(() {
                _isExpanded = !_isExpanded;
              }),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                _showRunningInstance ? Icons.local_play : Icons.local_play,
                size: 24,
              ),
              onPressed: () => setState(() {
                _showRunningInstance = !_showRunningInstance;
              }),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                _showDetails ? Icons.more_horiz : Icons.more_horiz,
                size: 24,
              ),
              onPressed: () => setState(() {
                _showDetails = !_showDetails;
              }),
            )),
      ]),
      if (_showDetails) _buildDetals(context),
      if (_showRunningInstance) _buildRunningInstance(context),
      if (_isExpanded) _buildExpanded(context),
    ]);
  }
}
