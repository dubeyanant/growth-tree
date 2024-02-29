import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NodeController extends GetxController {
  final supabase = Supabase.instance.client;
  RxList data = [].obs;

  fetchData() async {
    data.value = await supabase.from('tree').select();
    data.sort((a, b) => a['id'].compareTo(b['id']));
  }

  setHasChild(int id) async {
    final data = await supabase.from('tree').select().eq('parentNode', id);
    if (data.isNotEmpty) {
      await supabase.from('tree').update({'hasChild': true}).match({'id': id});
    } else {
      await supabase.from('tree').update({'hasChild': false}).match({'id': id});
    }
  }

  insertNode({required nodeTitle, required parentId}) async {
    await supabase
        .from('tree')
        .insert({'nodeTitle': nodeTitle, 'parentNode': parentId})
        .then((value) => setHasChild(parentId))
        .then((value) => fetchData());
  }

  deleteNode({required id, required parentId, required context}) async {
    bool canDelete = (await supabase
            .from('tree')
            .select()
            .match({'id': id, 'hasChild': false}))
        .isNotEmpty;
    if (canDelete) {
      await supabase
          .from('tree')
          .delete()
          .match({'id': id, 'hasChild': false})
          .then((value) => setHasChild(parentId))
          .then((value) => fetchData());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Node deleted'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete it\'s child node first'),
        ),
      );
    }
  }
}
