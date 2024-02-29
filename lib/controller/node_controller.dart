import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NodeController extends GetxController {
  final supabase = Supabase.instance.client;
  RxList data = [].obs;

  fetchData() async {
    data.value = await supabase.from('tree').select();
  }

  insertData({required nodeTitle, required parentNode}) async {
    await supabase
        .from('tree')
        .insert({'nodeTitle': nodeTitle, 'parentNode': parentNode});

    fetchData();
  }
}
