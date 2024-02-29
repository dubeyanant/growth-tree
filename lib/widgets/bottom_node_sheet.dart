import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:growth_tree/controller/node_controller.dart';

class BottomNodeSheet extends StatefulWidget {
  const BottomNodeSheet({super.key, required this.parentId});

  final int parentId;

  @override
  State<BottomNodeSheet> createState() => _BottomNodeSheetState();
}

class _BottomNodeSheetState extends State<BottomNodeSheet> {
  NodeController nc = Get.put(NodeController());
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      iconSize: 32,
      onPressed: () {
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
                              nc.insertData(
                                  nodeTitle: textController.text,
                                  parentNode: widget.parentId);
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
      icon: const Icon(Icons.add),
    );
  }
}
