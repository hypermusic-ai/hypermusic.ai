import 'package:flutter/material.dart';

// Models
import '../../../model/feature.dart';

//Views
import '../draggable/draggable_feature_item.dart';

// Controllers
import '../../../controller/data_interface.dart';

class FeatureListPanel extends StatelessWidget {
  final DataInterface registry;

  const FeatureListPanel({
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
              'Features',
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
            // asynchronous fetch feature names from registry 
            child: FutureBuilder<List<String>>(
              future: registry.getAllFeatureNames(),
              builder: (context, nameListSnapshot) {
                // still fetching...
                if (nameListSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } // handle error when connecting to registry
                else if (nameListSnapshot.hasError) {
                  return Center(child: Text('Error: ${nameListSnapshot.error}'));
                } // when asynchronous operation completed, display features
                else {
                  return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(4.0),
                          itemCount: nameListSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            
                            return FutureBuilder<Feature?>(
                              future: registry.getNewestFeature(nameListSnapshot.data![index]),
                              builder: (context, featureSnapshot) {
                                if (featureSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (featureSnapshot.hasError) {
                                  return Text('Error: ${featureSnapshot.error}');
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: DraggableFeatureItem(feature: featureSnapshot.data!),
                                  );
                                }
                              },
                            );
                    },
                  );
                }
              },
            ) 
          ),
        ],
      ),
    );
  }
}
