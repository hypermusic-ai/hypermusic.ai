import 'package:flutter/material.dart';

// Models
import '../../../model/transformation.dart';

// Views
import '../draggable/draggable_transformation_item.dart';

// Controllers
import '../../../controller/data_interface.dart';

class TransformationListPanel extends StatelessWidget {
  final DataInterface registry;

  const TransformationListPanel({
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
              'Transformations',
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
              future: registry.getAllTransformationsNames(),
              builder: (context, nameListSnapshot) {
                if (nameListSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!nameListSnapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No transformations available',
                      style: TextStyle(fontSize: 11),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4.0),
                  itemCount: nameListSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<Transformation?>(
                      future: registry.getNewestTransformation(nameListSnapshot.data![index]),
                      builder: (context, transformationSnapshot) {
                        if (transformationSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!transformationSnapshot.hasData) {
                          return const Center(
                            child: Text(
                              'No transformation available',
                              style: TextStyle(fontSize: 11),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: DraggableTransformationItem(
                            transformation: transformationSnapshot.data!,
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
