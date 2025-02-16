import 'package:flutter/material.dart';

// Models
import '../../../model/condition.dart';

//Views
import '../draggable/draggable_condition_item.dart';

// Controllers
import '../../../controller/data_interface.dart';

class ConditionListPanel extends StatelessWidget {
  final DataInterface registry;

  const ConditionListPanel({
    super.key,
    required this.registry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(2.0),
      ),
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Conditions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: FutureBuilder<List<String>>(
              future: registry.getAllConditionsNames(),
              builder: (context, nameListSnapshot) {
                if (nameListSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!nameListSnapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No conditions available',
                      style: TextStyle(fontSize: 11),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4.0),
                  itemCount: nameListSnapshot.data!.length,
                  itemBuilder: (context, index) {

                  return FutureBuilder<Condition?>(
                      future: registry.getNewestCondition(nameListSnapshot.data![index]),
                      builder: (context, conditionSnapshot) {
                        if (conditionSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!conditionSnapshot.hasData) {
                          return const Center(
                            child: Text(
                              'No conditions available',
                              style: TextStyle(fontSize: 11),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: DraggableConditionItem(
                            condition: conditionSnapshot.data!,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
