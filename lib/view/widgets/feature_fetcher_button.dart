import 'package:flutter/material.dart';

// Views
import '../pages/feature_fetcher_page.dart';

// Controllers
import '../../controller/data_interface.dart';


class FeatureFetcherButton extends StatelessWidget {

  final DataInterface registry;

  FeatureFetcherButton({super.key, required this.registry});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.folder_open),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeatureFetcherPage(registry: registry),
          ),
        );
      },
    );
  }
}
