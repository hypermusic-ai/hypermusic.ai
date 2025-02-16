import 'package:flutter/material.dart';

//Views
import '../widgets/left_side_panel/left_side_panel.dart';
import '../widgets/editor/pt_builder_panel.dart';
import '../widgets/top_nav_bar.dart';

//Controllers
import '../../controller/data_interface.dart';

class EditPage extends StatefulWidget {
  final DataInterface registry;

  EditPage({super.key, required this.registry});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<LeftSidePanelState> leftSidePanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(showPagesLinks: true),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: LeftSidePanel(
              registry: widget.registry,
              key: leftSidePanelKey,
            ),
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: FeatureBuilderPanel(
              registry: widget.registry,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.05),
              child: const Center(
                child: Text(
                  'Placeholder for future content',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
