import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NodeController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'nodesData';

  RxList data = [].obs;

  fetchData() async {
    data.value = await _supabase.from(_tableName).select();
    data.sort((a, b) => a['id'].compareTo(b['id']));
  }

  setHasChild(int id) async {
    final data = await _supabase.from(_tableName).select().eq('parentNode', id);
    if (data.isNotEmpty) {
      await _supabase
          .from(_tableName)
          .update({'hasChild': true}).match({'id': id});
    } else {
      await _supabase
          .from(_tableName)
          .update({'hasChild': false}).match({'id': id});
    }
  }

  insertNode({required nodeTitle, required parentId}) async {
    await _supabase
        .from(_tableName)
        .insert({'nodeTitle': nodeTitle, 'parentNode': parentId})
        .then((value) => setHasChild(parentId))
        .then((value) => fetchData());
  }

  deleteNode({required id, required parentId, required context}) async {
    bool canDelete = (await _supabase
            .from(_tableName)
            .select()
            .match({'id': id, 'hasChild': false}))
        .isNotEmpty;
    if (canDelete) {
      await _supabase
          .from(_tableName)
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
