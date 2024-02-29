import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:growth_tree/screens/add_node.dart';
import 'package:growth_tree/screens/graph.dart';
import 'package:growth_tree/controller/node_controller.dart';

NodeController nc = Get.put(NodeController());

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_DB_URL']}',
    anonKey: '${dotenv.env['SUPABASE_PUBLIC_ANON_KEY']}',
  );

  nc.fetchData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MaterialApp(
        title: 'Growth Tree',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: nc.data.isEmpty
            ? const AddNodeScreen(title: 'Growth Tree')
            : GraphScreen(data: nc.data, title: 'Growth Tree'),
      ),
    );
  }
}
