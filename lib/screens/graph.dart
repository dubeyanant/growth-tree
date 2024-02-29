import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graphview/GraphView.dart' as gv;

import 'package:growth_tree/controller/node_controller.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key, required this.data, required this.title});

  final List data;
  final String title;

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final _formKey = GlobalKey<FormState>();
  gv.Graph graph = gv.Graph()..isTree = true;
  TextEditingController textController = TextEditingController();

  void graphCreator() {
    graph = gv.Graph()..isTree = true;
    for (var element in widget.data) {
      if (element['parentNode'] != 0) {
        graph.addEdge(
          gv.Node.Id(element['parentNode']),
          gv.Node.Id(element['id']),
        );
      }
    }
  }

  void _showPopupMenu(
      BuildContext context, Offset offset, int id, int parentId) async {
    NodeController nc = Get.put(NodeController());

    double left = offset.dx;
    double top = offset.dy;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      items: [
        PopupMenuItem<String>(
          onTap: () {
            textController.text = '';
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add a node',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            iconSize: 30,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  labelText: 'Node title',
                                  hintText: 'Enter a node title',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter a title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Adding Node'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                  await nc.insertNode(
                                    nodeTitle: textController.text,
                                    parentId: id,
                                  );
                                  setState(() {
                                    graphCreator();
                                  });
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Text('Add Child'),
        ),
        PopupMenuItem<String>(
          onTap: () async {
            await nc.deleteNode(id: id, parentId: parentId, context: context);
            setState(() {
              graphCreator();
            });
          },
          child: const Text('Delete Node'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    graphCreator();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: InteractiveViewer(
        constrained: false,
        maxScale: 2,
        minScale: 1,
        boundaryMargin: const EdgeInsets.all(16),
        child: gv.GraphView(
          graph: graph,
          algorithm: gv.BuchheimWalkerAlgorithm(
            gv.BuchheimWalkerConfiguration(),
            gv.TreeEdgeRenderer(
              gv.BuchheimWalkerConfiguration(),
            ),
          ),
          paint: Paint()
            ..color = Colors.green
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
          builder: (gv.Node node) {
            int a = node.key?.value ?? 0;
            return growthCircleNode(a);
          },
        ),
      ),
    );
  }

  Widget growthCircleNode(int a) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (details) => _showPopupMenu(
            context,
            details.globalPosition,
            widget.data.where((element) => element['id'] == a).toList()[0]
                ['id'],
            widget.data.where((element) => element['id'] == a).toList()[0]
                ['parentNode'],
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Icon(Icons.star),
          ),
        ),
        const SizedBox(height: 4),
        Text(widget.data.where((element) => element['id'] == a).toList()[0]
            ['nodeTitle']),
        const SizedBox(height: 8),
      ],
    );
  }
}
