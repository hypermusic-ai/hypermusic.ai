import 'package:flutter/material.dart';

import '../../../../controller/condition_editor_controller.dart';

class ConditionNode extends StatelessWidget {
  final ConditionEditorController conditionController;

  const ConditionNode({
    super.key,
    required this.conditionController
  });

  void _onRemoveCondition()
  {
    //conditionController.removeCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.orange[50],
        ),
        child: Column(
          children: [
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  color: Colors.orange,
                  child: Text(
                    conditionController.value.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),


            // "x" button to remove condition in top right corner

              IconButton(
                icon: const Icon(Icons.close, size: 16),
                color: Colors.red,
                onPressed: _onRemoveCondition,
              ),
          ],
        ),
      ),
    );
  }
}
