import 'package:flutter/material.dart';

// Views
import 'feature_list_panel.dart';
import 'transformation_list_panel.dart';
import 'condition_list_panel.dart';

// Controllers
import '../../../controller/data_interface.dart';

class LeftSidePanel extends StatefulWidget {

  final DataInterface registry;

  const LeftSidePanel({
    super.key,
    required this.registry,
  });

  @override
  State<LeftSidePanel> createState() => LeftSidePanelState();
}

class LeftSidePanelState extends State<LeftSidePanel> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeatureListPanel(
              registry: widget.registry,
            ),
            const SizedBox(height: 4),
            TransformationListPanel(
              registry: widget.registry,
            ),
            const SizedBox(height: 4),
            ConditionListPanel(
              registry: widget.registry,
            ),
          ],
        ),
      ),
    );
  }
}
