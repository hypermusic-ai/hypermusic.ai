import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:developer' as developer;

// Models
import '../../../../model/feature.dart'; // todo - zrobić bridge żeby nie było modeli w view ( controller?)
import '../../../../model/transformation.dart'; // todo 

// Views
import '../pt_editor_node.dart';
import '../running_instance/running_instance_editor.dart';
import '../transformation/transformation_node.dart';
import '../feature/feature_details_editor.dart';
import '../condition/condition_node.dart';

//Controllers
import '../../../../controller/feature_editor_controller.dart';
import '../../../../controller/running_instance_editor_controller.dart';
import '../../../../controller/condition_editor_controller.dart';
import '../../../../controller/transformation_editor_controller.dart';


class PTTreeEditorNode extends PTEditorNodeBase {

  PTTreeEditorNode({
    super.key,
    required super.registry,
    required super.featureController,
  });

  @override
  State<PTTreeEditorNode> createState() => _PTTreeEditorNodeState();
}

class _PTTreeEditorNodeState extends State<PTTreeEditorNode> {

  List<PTTreeEditorNode> childrenWidgets = [];
  Map<FeatureEditorController, List<TransformationNode>> transformationWidgets = {};

  final RunningInstanceEditorController _runningInstanceEditorController = RunningInstanceEditorController();
  final ConditionEditorController _conditionEditorController = ConditionEditorController();

  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<Digest?> _versionController = ValueNotifier<Digest?>(null);
  final ValueNotifier<bool> _highlightedController = ValueNotifier<bool>(false);
  
  bool _isExpanded = false;
  bool _showDetails = false;
  bool _showRunningInstance = false;

  @override
  void dispose() {

    developer.log("${widget.featureController.value.name} dispose", name: 'hypermusic.app.pt_editor_node');

    _nameController.dispose();
    _versionController.dispose();
    _highlightedController.dispose();

    _runningInstanceEditorController.dispose();
    _conditionEditorController.dispose();

    widget.featureController.removeListener(_onFeatureChanged);

    super.dispose();
  }

  @override
  void initState() {
    developer.log("${widget.featureController.value.name} init state", name: 'hypermusic.app.pt_editor_node');
    
    setState(() {_nameController.text = widget.featureController.value.name;});    

    widget.featureController.addListener(_onFeatureChanged);
    
    _buildChildren();
    advancedVersionTest();

    super.initState();
  }

  void _onFeatureChanged()
  {
    developer.log("${widget.featureController.value.name}  _onFeatureChanged", name: 'hypermusic.app.pt_editor_node');
    advancedVersionTest();
    setState(() {_nameController.text = widget.featureController.value.name;});
  }

  void advancedVersionTest() async
  {
    _versionController.value = await widget.registry.containsFeature(widget.featureController.value);
    developer.log("${widget.featureController.value.name} v.${_versionController.value} _advancedEqualityTest", name: 'hypermusic.app.pt_editor_node');
  }

  void _buildChildren() {
    developer.log("${widget.featureController.value.name}  buildChildren", name: 'hypermusic.app.pt_editor_node');
    
    transformationWidgets.clear();
    childrenWidgets.clear();
    for(int compositeIndex = 0; compositeIndex < widget.featureController.value.composites.length; compositeIndex++)
    {
        FeatureEditorController compositeController = widget.featureController.compositesControllers[compositeIndex];

        childrenWidgets.add(
          PTTreeEditorNode(
            key: Key(compositeController.value.name),
            registry: widget.registry,
            featureController: compositeController,
        ));

        transformationWidgets[compositeController] = [];
        for(int transformIndex = 0; transformIndex < (widget.featureController.value.transformationsMap[compositeController.value] ?? []).length; transformIndex++)
        {
          TransformationEditorController transformationController =  widget.featureController.transformationControllers[compositeController.value]![transformIndex];
          transformationWidgets[compositeController]!.add(
            TransformationNode(
              key: Key(transformationController.value.name),
              transformationController: transformationController,
            )
          );
        }

    }
    setState(() {});
  }

  void _onAcceptWithDetails(DragTargetDetails<Feature> details) 
  {
    developer.log("${widget.featureController.value.name}  _onAcceptWithDetails", name: 'hypermusic.app.pt_editor_node');
    widget.featureController.updateFeature(details.data.copyWith()); // feature updated
    _buildChildren();
  }

  void _onCompositeRemoved(PTTreeEditorNode featureWidget, int compositeIndex) {
    developer.log("${widget.featureController.value.name} _onCompositeRemoved ${featureWidget}", name: 'hypermusic.app.pt_editor_node');
    childrenWidgets.remove(featureWidget);
    widget.featureController.removeComposite(featureWidget.featureController.value); // feature updated
    childrenWidgets.remove(featureWidget);
  }

  void _onCompositeAdded(DragTargetDetails<Feature> details) {
    developer.log("${widget.featureController.value.name} _onCompositeAdded ${details.data.name}", name: 'hypermusic.app.pt_editor_node');
    Feature composite = details.data.copyWith();
    widget.featureController.addComposite(composite); // feature updated
    FeatureEditorController compositeController = widget.featureController.compositesControllers.last;
    childrenWidgets.add(
          PTTreeEditorNode(
            key: Key(compositeController.value.name),
            registry: widget.registry,
            featureController: compositeController,
        )
    );
  }

  void _onNameChanged(String value) {
    developer.log("${widget.featureController.value.name}  _onNameChanged", name: 'hypermusic.app.pt_editor_node');
    widget.featureController.updateName(value); // feature updated
  }

  void _onTransformationAdded(PTTreeEditorNode composite, DragTargetDetails<Transformation> details) {
    developer.log("${widget.featureController.value.name} _onTransformationAdded ${composite.featureController.value.name} -> ${details.data.name}", name: 'hypermusic.app.pt_editor_node');
    widget.featureController.addTransformation(composite.featureController.value, details.data.copyWith());
    transformationWidgets[composite.featureController]?.add(
      TransformationNode(
        transformationController: widget.featureController.transformationControllers[composite.featureController.value]!.last
      )
    );
  }

  void _onTransformationRemoved(PTTreeEditorNode composite, TransformationNode transformationWidget) {
    developer.log("${widget.featureController.value.name} _onTransformationRemoved ${composite.featureController.value.name} -> ${transformationWidget.transformation.name}", name: 'hypermusic.app.pt_editor_node');
    widget.featureController.removeTransformation(composite.featureController.value, transformationWidget.transformation);
    transformationWidgets[composite.featureController]?.remove(transformationWidget);
  }

  Widget _buildExpanded(BuildContext context) {
    return Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end, // Align to the left
                children: [
                  ListView.builder(
                    shrinkWrap:true, 
                    itemCount: childrenWidgets.length,
                    itemBuilder: (context, compositeIndex) {
                      PTTreeEditorNode childWidget = childrenWidgets[compositeIndex];
                      Widget transformMapWidgets = ListView.builder( 
                          shrinkWrap:true, 
                          itemCount: transformationWidgets[childWidget.featureController]?.length ?? 0,
                          itemBuilder: (context, transformationIndex) {
                            TransformationNode transformationWidget = transformationWidgets[childWidget.featureController]![transformationIndex];
                            return Padding( 
                                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Row(
                                  children: [
                                    IconButton( // transformation remove button
                                      icon: const Icon(Icons.remove),
                                      color: Colors.red,
                                      iconSize: 16,
                                      onPressed: () => _onTransformationRemoved(childWidget, transformationWidget),
                                    ),
                                     Expanded( // transformation editor
                                       child: transformationWidget,
                                     )
                                  ],
                                )
                            );
                          }
                        );

                      DragTarget<Transformation> transformAddWidget = 
                        DragTarget<Transformation>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.lightGreen.withOpacity(0.3),
                                ),
                                height: 32,
                                child: Row(mainAxisAlignment : MainAxisAlignment.center,
                                    children:
                                    [ 
                                      Icon(Icons.add, color: Colors.lightGreen.withOpacity(0.5)),
                                      Icon(Icons.build, color: Colors.lightGreen.withOpacity(0.5))
                                    ],
                                  ),
                              );
                            },
                            onAcceptWithDetails: (details) => _onTransformationAdded(childWidget, details),
                          );

                      // display transformMapWidgets and childWidget
                       return Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: 
                          Column(
                            children: [
                              transformMapWidgets,
                              transformAddWidget,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  // child remove button
                                  IconButton(icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  iconSize: 16,
                                  onPressed: () => _onCompositeRemoved(childWidget, compositeIndex),
                                  ),
                                  // child widget
                                  Expanded(child: childWidget)
                                ]
                              )
                          ],
                        )
                      );
                    }
                  ),
                  // feature add
                    DragTarget<Feature>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Colors.lightGreen.withOpacity(0.3),
                        ),
                        height: 32,
                        child: Row(
                                mainAxisAlignment : MainAxisAlignment.center,
                                children: [
                                    Icon(Icons.add, color: Colors.lightGreen.withOpacity(0.5)),
                                    Icon(Icons.show_chart, color: Colors.lightGreen.withOpacity(0.5))
                                  ]
                                ),
                              
                        );
                      },
                      onAcceptWithDetails: (details) => _onCompositeAdded(details),
                    ),

              ])
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(child: 
        DragTarget<Feature>(
            builder: (context, candidateData, rejectedData) {
              return 
                TextField( // feature name
                  controller: _nameController,
                  onSubmitted: (value) {_onNameChanged(value);},
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
                      borderSide: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                );
            },
            onAcceptWithDetails: (details) => _onAcceptWithDetails(details),
          ),
        ),

        ValueListenableBuilder<Digest?>(
            builder: (BuildContext context, Digest? version, Widget? child) {
                if(version == null)return Container();
                return Expanded( child:
                        LayoutBuilder( 
                        builder: (context, constraints) {
                          double width = constraints.maxWidth < 128.0 ? constraints.maxWidth : 128.0;
                          int maxChars = (width / 9).floor(); // 9px per character approximation
                          String displayText = version.toString();
                          if (displayText.length > maxChars) {
                            displayText = '${displayText.substring(0, maxChars > 3 ? maxChars - 3 : 0)}...';
                          }
                          if(maxChars < 3)displayText="";
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              displayText,
                              style: 
                                const TextStyle(fontSize: 10, color: Colors.grey),
                              )
                            );
                          }
                        )
                );
              },
            valueListenable: _versionController,
        ),
        Row( children: [
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton( // _isExpanded button
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32,minHeight: 32,),
              icon: Icon(
                _isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 24,
              ),
              onPressed: () => setState(() {_isExpanded = !_isExpanded;}),
            )),
        
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton( // _showRunningInstance button
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                _showRunningInstance ? Icons.local_play : Icons.local_play,
                size: 24,
              ),
              onPressed: () => setState(() {_showRunningInstance = !_showRunningInstance;}),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton( // _showDetails button
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32,),
              icon: Icon(
                _showDetails ? Icons.more_horiz : Icons.more_horiz,
                size: 24,
              ),
              onPressed: () => setState(() {_showDetails = !_showDetails;}),
            )),
        ])

      ]),
      if (_showDetails) FeatureDetailsEditor(featureEditorController: widget.featureController),
      if (_showRunningInstance) ...
      [
        RunningInstanceEditor(runningInstanceEditorController: _runningInstanceEditorController),
        ConditionNode(conditionController: _conditionEditorController),
      ],
      if (_isExpanded) _buildExpanded(context),
    ]);
  }
}
