// panel_header.dart provides a reusable header widget for each panel with a title and optional sorting icon.

import 'package:flutter/material.dart'; //To access widgets, colors, icons, etc.

class PanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSort;

  const PanelHeader({super.key, required this.title, this.onSort});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Wrap the title in an Expanded to prevent overflow
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Truncate if too long
          ),
        ),
        if (onSort != null)
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: onSort,
          ),
      ],
    );
  }
}
