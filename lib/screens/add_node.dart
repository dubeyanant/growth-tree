import 'package:flutter/material.dart';

import 'package:growth_tree/widgets/bottom_node_sheet.dart';

class AddNodeScreen extends StatelessWidget {
  const AddNodeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomNodeSheet(parentId: 0),
            SizedBox(height: 8),
            Text('Add a growth node')
          ],
        ),
      ),
    );
  }
}
