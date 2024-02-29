import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:growth_tree/controller/node_controller.dart';
import 'package:growth_tree/widgets/bottom_node_sheet.dart';
import 'package:growth_tree/widgets/growth_nodes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    NodeController nc = Get.put(NodeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Obx(
        () => Center(
          child: nc.data.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BottomNodeSheet(parentId: 0),
                    SizedBox(height: 8),
                    Text('Add a growth node')
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: nc.data
                          .map(
                            (element) => GrowthNodes(
                              nodeTitle: element['nodeTitle'],
                              nodeId: element['id'],
                              parentId: element['parentNode'],
                              isRoot: element['parentNode'] != 0 ? true : false,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
