import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ska_crm/provider/provider.dart';

import 'public/main_navigation.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => TaskProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sri Krishna Ads',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainNavigation(),
    );
  }
}
