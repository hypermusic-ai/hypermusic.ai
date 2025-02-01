import 'package:flutter/material.dart';

//Views
import 'package:hypermusic/view/widgets/editor/pt_editor_node.dart';

class PTEditor extends StatefulWidget {
  
  const PTEditor({super.key});

  @override
  State<PTEditor> createState() => _PTEditorState();
}

class _PTEditorState extends State<PTEditor> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
                Row(
                    children: [
                      Expanded(child: 
                        PTEditorNode(),
                      )
                    ],
                  )
          ],
        ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
