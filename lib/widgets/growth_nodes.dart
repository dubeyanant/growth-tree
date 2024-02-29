import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:growth_tree/controller/node_controller.dart';

class GrowthNodes extends StatelessWidget {
  GrowthNodes({
    super.key,
    required this.nodeTitle,
    required this.nodeId,
    required this.parentId,
    required this.isRoot,
  });

  final String nodeTitle;
  final int nodeId;
  final int parentId;
  final bool isRoot;

  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  void _showPopupMenu(BuildContext context, Offset offset, int id) async {
    NodeController nc = Get.put(NodeController());

    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      items: [
        PopupMenuItem<String>(
          onTap: () {
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  nc.insertNode(
                                      nodeTitle: textController.text,
                                      parentId: id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Adding Node'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: const Text('Add Child'),
        ),
        PopupMenuItem<String>(
          onTap: () =>
              nc.deleteNode(id: id, parentId: parentId, context: context),
          child: const Text('Delete Node'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRoot
            ? Container(
                height: 32,
                width: 2,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 8),
        GestureDetector(
          onTapDown: (details) =>
              _showPopupMenu(context, details.globalPosition, nodeId),
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
        Text(nodeTitle),
        const SizedBox(height: 8),
      ],
    );
  }
}
