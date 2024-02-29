import 'package:flutter/material.dart';
import 'dart:math';

import 'package:graphview/GraphView.dart' as gv;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 5.6,
        child: gv.GraphView(
          graph: graph,
          algorithm:
              gv.BuchheimWalkerAlgorithm(builder, gv.TreeEdgeRenderer(builder)),
          paint: Paint()
            ..color = Colors.green
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
          builder: (gv.Node node) {
            // I can decide what widget should be shown here based on the id
            var a = node.key?.value as int;
            return rectangleWidget(a);
          },
        ),
      ),
    );
  }

  Random r = Random();

  Widget rectangleWidget(int a) {
    return InkWell(
      onTap: () {
        print('clicked on $a');
      },
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
            ],
          ),
          child: Text('Node $a')),
    );
  }

  final gv.Graph graph = gv.Graph()..isTree = true;
  gv.BuchheimWalkerConfiguration builder = gv.BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    final node1 = gv.Node.Id(1);
    final node2 = gv.Node.Id(2);
    final node3 = gv.Node.Id(3);
    final node4 = gv.Node.Id(4);
    final node5 = gv.Node.Id(5);
    final node6 = gv.Node.Id(6);
    final node8 = gv.Node.Id(7);
    final node7 = gv.Node.Id(8);
    final node9 = gv.Node.Id(9);
    final node10 = gv.Node.Id(10);
    final node11 = gv.Node.Id(11);
    final node12 = gv.Node.Id(12);

    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3, paint: Paint()..color = Colors.red);
    graph.addEdge(node1, node4, paint: Paint()..color = Colors.blue);
    graph.addEdge(node2, node5);
    graph.addEdge(node2, node6);
    graph.addEdge(node6, node7, paint: Paint()..color = Colors.red);
    graph.addEdge(node6, node8, paint: Paint()..color = Colors.red);
    graph.addEdge(node4, node9);
    graph.addEdge(node4, node10, paint: Paint()..color = Colors.black);
    graph.addEdge(node4, node11, paint: Paint()..color = Colors.red);
    graph.addEdge(node11, node12);

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (gv.BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }
}
