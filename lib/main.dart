import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Providers
import 'providers/meta_mask_provider.dart';

// Views
import 'view/pages/home_page.dart';
import 'view/pages/edit_page.dart';
import 'view/pages/explore_page.dart';
import 'view/pages/trade_page.dart';
import 'view/pages/profile_page.dart';

//Controllers
import 'controller/data_interface.dart';
import 'controller/registry.dart';

import 'registry_initializer.dart';

void fetchFeatures(DataInterface registry) async {
  final features = await registry.getAllFeatureNames();
  print("Features: $features");
  print("Test Build Web");
}

void main() async {

  final DataInterface registry = Registry();

  // Initialize the registry with default features and transformations
  await RegistryInitializer.initialize(registry);
  fetchFeatures(registry);

  runApp(
    MultiProvider(
      providers: [
        Provider<DataInterface>.value(value: registry),
        ChangeNotifierProvider(
          create: (_) => MetaMaskProvider()..start(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hypermusic.ai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.sometypeMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFF007BFF)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Color(0xFF007BFF)),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/edit',
      routes: {
        '/': (context) => HomePage(registry: Provider.of<DataInterface>(context, listen: false)),
        '/edit': (context) => EditPage(registry: Provider.of<DataInterface>(context, listen: false),),
        '/explore': (context) => ExplorePage(),
        '/trade': (context) => TradePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
