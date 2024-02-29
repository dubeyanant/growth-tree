import 'package:flutter/material.dart';

class GrowthNodes extends StatelessWidget {
  const GrowthNodes({super.key, required this.nodeTitle});

  final String nodeTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: const Icon(Icons.star),
        ),
        const SizedBox(height: 4),
        Text(nodeTitle),
        const SizedBox(height: 8),
        Container(
          height: 32,
          width: 2,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
