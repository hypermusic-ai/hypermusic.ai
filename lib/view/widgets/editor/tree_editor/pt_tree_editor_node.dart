import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

// Models
import '../../../../model/feature.dart'; // todo - zrobić bridge żeby nie było modeli w view ( controller?)
import '../../../../model/transformation.dart'; // todo 

// Views
import '../pt_editor_node.dart';
import '../running_instance/running_instance_editor.dart';
import '../transformation/transformation_node.dart';
import '../feature/feature_details_editor.dart';

//Controllers
import '../../../../controller/feature_editor_controller.dart';
import '../../../../controller/running_instance_editor_controller.dart';
import '../../../../controller/condition_editor_controller.dart';
import '../../../../controller/transformation_editor_controller.dart';


class PTTreeEditorNode extends PTEditorNodeBase {
  
  final RunningInstanceEditorController runningInstanceEditorController;
  final ConditionEditorController conditionEditorController;

  PTTreeEditorNode({
    super.key,
    required super.registry,
    super.onUpdated,
    super.featureController,
  })  : runningInstanceEditorController = RunningInstanceEditorController(),
        conditionEditorController = ConditionEditorController();

  @override
  State<PTTreeEditorNode> createState() => _PTTreeEditorNodeState();
}

class _PTTreeEditorNodeState extends State<PTTreeEditorNode> {
  bool _isExpanded = false;
  bool _showDetails = false;
  bool _showRunningInstance = false;
  bool _dirty = false;
  Digest? _version;

  List<FeatureEditorController> _subFeatureControllerNodes = [];
  Map<Feature, List<TransformationEditorController>> _subTransformationNodes = {};

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {_pushData(); _pullData();});
  }

  @override
  void dispose() {

    _nameController.dispose();

    for(List<TransformationEditorController> subTransformationList in _subTransformationNodes.values) 
    {
      for(TransformationEditorController transformationController in subTransformationList)
      {
        transformationController.dispose();
      }
      subTransformationList.clear();
    }
    _subTransformationNodes.clear();

    for(FeatureEditorController subNode in _subFeatureControllerNodes) 
    {
      subNode.dispose();
    }
    _subFeatureControllerNodes.clear();

    super.dispose();
  }

  /// fetch the current composites from the controller 
  /// and create new sub-controllers based on them
  /// <br /> PUSH operation - will create and update sub-controllers
  void _pushData() {
    print("${widget.feature.name} _pushData");
    _subFeatureControllerNodes.clear();
    for (var subFeature in widget.feature.composites) {
      _subFeatureControllerNodes.add(FeatureEditorController(feature : subFeature.copyWith()));

      if(widget.feature.transformationsMap[subFeature] == null) continue;

      _subTransformationNodes[subFeature] = [];
      List<Transformation> transformations = widget.feature.transformationsMap[subFeature]!;

      _subTransformationNodes[subFeature]!.addAll(
        transformations.map((transform) => TransformationEditorController(transformation: transform))
      );

    }
  }

  /// fetch composites from sub-controllers
  /// and update the current controller
  /// <br /> PULL operation - won't create or update sub-controllers
  void _pullData() {
    print("${widget.feature.name} _pullData");

    _nameController.text = widget.feature.name;
    widget.feature.composites.clear();
    for (var subNode in _subFeatureControllerNodes) {
      widget.feature.composites.add(subNode.value);

      if(_subTransformationNodes[subNode.value] == null) continue;
      widget.feature.transformationsMap[subNode.value] = _subTransformationNodes[subNode.value]!.map((element) => element.value).toList();
    }
    // Direct async invocation - immediate call
    // This is non-blocking and runs in the background
    _advancedEqualityTest();
  }

  void _onAcceptWithDetails(DragTargetDetails<Feature> details) {
    widget.featureController.updateFeature(details.data.copyWith());
    // since we obtained new feature from drag target we need to update sub-controllers
    setState(() {_pushData();});
    _update();
  }

  void _onNameChanged(String value) {
    if (widget.feature.name == _nameController.text)return;
    widget.featureController.updateFeature(widget.feature.copyWith(name: _nameController.text));
    _update();
  }

  void _onCompositeRemoved(Feature feature) {
    print("${widget.feature.name} _onCompositeRemoved ${feature.name}");
    _subFeatureControllerNodes.removeAt(_subFeatureControllerNodes.indexWhere((element) => element.value == feature));
    _subTransformationNodes[feature] = [];
    _update();
  }

  void _onCompositeAdded(DragTargetDetails<Feature> details) {
    print("${widget.feature.name} _onCompositeAdded ${details.data.name}");
    _subFeatureControllerNodes.add(FeatureEditorController(feature : details.data));
    _update();
  }

  void _onTransformationAdded(Feature feature, DragTargetDetails<Transformation> details) {
    print("${widget.feature.name} _onTransformationAdded ${feature.name} -> ${details.data.name}");
    if(_subTransformationNodes[feature] == null) _subTransformationNodes[feature] = [];
    _subTransformationNodes[feature]!.add(TransformationEditorController(transformation : details.data));
    _update();
  }

  void _onTransformationRemoved(Feature feature, Transformation transformation) {
    print("${widget.feature.name} _onTransformationRemoved ${feature.name} -> ${transformation.name}");
    if(_subTransformationNodes[feature] == null) _subTransformationNodes[feature] = [];
    _subTransformationNodes[feature]!.removeAt(
      _subTransformationNodes[feature]!.indexWhere((element) => element.value == transformation));
    _update();
  }

  void _update()
  {
    print("${widget.feature.name} _update");
    
    setState(() {_pullData();});

    if(widget.onUpdated == null)return;
    widget.onUpdated!();
  }

  void _advancedEqualityTest() async
  {
    print("${widget.feature.name} _advancedEqualityTest");
    _version = await widget.registry.containsFeature(widget.feature);
    if(_version == null)
    {
      setState(() {_dirty = true;});
      return;
    }
    setState(() {_dirty = false;});
  }

  Widget _buildExpanded(BuildContext context) {
    return Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                children: [
                  for (var subNode in _subFeatureControllerNodes) ...[ // iterate over feature nodes
                    Container(
                      decoration: BoxDecoration(
                      border: Border.all(color: _dirty ? Colors.lightGreen : Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16), 
                    ),
                    child: Stack(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Flexible(
                                flex: 1,
                                child: // transformation list
                                ListView.builder(
                                  shrinkWrap:true, 
                                  itemCount: _subTransformationNodes[subNode.value] == null ?   
                                    0 : _subTransformationNodes[subNode.value]!.length,
                                  itemBuilder: (context, index) {
                                    return Padding( // transformation remove
                                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            color: Colors.red,
                                            iconSize: 16,
                                            onPressed: () => _onTransformationRemoved(subNode.value, _subTransformationNodes[subNode.value]![index].value),
                                          ),
                                          Expanded(
                                            child: TransformationNode(
                                              transformationController: _subTransformationNodes[subNode.value]![index],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ]),
                              // transformation add
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
                                onAcceptWithDetails: (details) => _onTransformationAdded(subNode.value, details),
                              ),
                            Padding( // recursivly spawn new editor for composite
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: 
                                PTTreeEditorNode(key: ValueKey(subNode.value.name),
                                  registry: widget.registry, 
                                  onUpdated: _update, 
                                  featureController: subNode)
                            ),
                          ]),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton( // feature remove
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          iconSize: 16,
                          onPressed: () => _onCompositeRemoved(subNode.value),
                        ),
                      ),
                    ]))
                  ],
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
                      borderSide: BorderSide(color: _dirty? Colors.lightGreen : Theme.of(context).dividerColor),
                    ),
                  ),
                );
            },
            onAcceptWithDetails: (details) => _onAcceptWithDetails(details),
          ),
        ),
        if(_version != null) ...[
          Expanded( child:
                LayoutBuilder( 
                builder: (context, constraints) {
                double width = constraints.maxWidth < 128.0 ? constraints.maxWidth : 128.0;
                int maxChars = (width / 9).floor(); // 9px per character approximation
                String displayText = _version.toString();
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
          )
        ],

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
      if (_showRunningInstance) RunningInstanceEditor(runningInstanceEditorController: widget.runningInstanceEditorController),
      if (_isExpanded) _buildExpanded(context),
    ]);
  }
}
