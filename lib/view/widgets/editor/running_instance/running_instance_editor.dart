import 'package:flutter/material.dart';

// Controllers
import 'package:hypermusic/controller/running_instance_editor_controller.dart';

class RunningInstanceEditor extends StatefulWidget {

  final RunningInstanceEditorController runningInstanceEditorController;

  const RunningInstanceEditor({super.key, required this.runningInstanceEditorController,});

  @override
  State<RunningInstanceEditor> createState() => _RunningInstanceEditorState();
}

class _RunningInstanceEditorState extends State<RunningInstanceEditor> {

  late TextEditingController _startPointController;
  late TextEditingController _transformationStartIndexController;
  late TextEditingController _transformationEndIndexController;

  @override
  void initState() {
    super.initState();

    final runningInstance = widget.runningInstanceEditorController.value;

    _startPointController = TextEditingController(text: runningInstance.startPoint.toString());
    _transformationStartIndexController = TextEditingController(text: runningInstance.transformationStartIndex.toString());
    _transformationEndIndexController = TextEditingController(text: runningInstance.transformationEndIndex.toString());


    _startPointController.addListener(  
      () => runningInstance.copyWith(startPoint: int.tryParse(_startPointController.text) ?? 0)
    );

    _transformationStartIndexController.addListener(
      () => runningInstance.copyWith(transformationStartIndex: int.tryParse(_transformationStartIndexController.text) ?? 0)
    );

    _transformationEndIndexController.addListener(
      () => runningInstance.copyWith(transformationEndIndex: int.tryParse(_transformationEndIndexController.text) ?? 0)
    );
  }

  @override
  void dispose() {
    _startPointController.dispose();
    _transformationStartIndexController.dispose();
    _transformationEndIndexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startPointController.text = widget.runningInstanceEditorController.value.startPoint.toString();

    return 
    Container(
      decoration: 
        BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor)
        ),
      child :
        Column(
          children: [
            Row(
              children: [
                Padding( padding: const EdgeInsets.all(4.0),
                child:
                SizedBox(
                  width: 50,
                  height: 20,
                  child: TextField(
                    controller: _startPointController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 11),
                    decoration: const InputDecoration(
                      labelText: 'start',
                      labelStyle: TextStyle(fontSize: 11),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Keep vertical padding minimal
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
                )
              ],
            ),
            Row(
              children: [ 
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:             const Text('Transformation range: ', style: TextStyle(fontSize: 11),),
                ),
                Padding( padding: const EdgeInsets.all(4.0),
                child:
                SizedBox(
                  width: 50,
                  height: 20,
                  child: TextField(
                    controller: _transformationStartIndexController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 11),
                    decoration: const InputDecoration(
                      labelText: 'from',
                      labelStyle: TextStyle(fontSize: 11),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Keep vertical padding minimal
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
                ),
                Padding( padding: const EdgeInsets.all(4.0),
                child:
                SizedBox(
                  width: 50,
                  height: 20,
                  child: TextField(
                    controller: _transformationEndIndexController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 11),
                    decoration: const InputDecoration(
                      labelText: 'to',
                      labelStyle: TextStyle(fontSize: 11),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Keep vertical padding minimal
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
               )
              ],
            ),
          ],
        )
    );
  }
}
