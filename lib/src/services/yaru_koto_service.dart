import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/yaru_koto.dart';

class YaruKotoService {
  static const String _key = 'yaru_koto_list';

  /// 全てのプロジェクトを取得
  Future<List<YaruKoto>> getAllYaruKoto() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => YaruKoto.fromJson(json)).toList();
  }

  /// プロジェクトを保存
  Future<void> saveYaruKoto(List<YaruKoto> yaruKotoList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(yaruKotoList.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  /// 新しいプロジェクトを追加
  Future<void> addYaruKoto(YaruKoto yaruKoto) async {
    final list = await getAllYaruKoto();
    list.add(yaruKoto);
    await saveYaruKoto(list);
  }

  /// プロジェクトを更新
  Future<void> updateYaruKoto(YaruKoto updatedYaruKoto) async {
    final list = await getAllYaruKoto();
    final index = list.indexWhere((e) => e.id == updatedYaruKoto.id);
    if (index != -1) {
      list[index] = updatedYaruKoto;
      await saveYaruKoto(list);
    }
  }

  /// プロジェクトを削除
  Future<void> deleteYaruKoto(String id) async {
    final list = await getAllYaruKoto();
    list.removeWhere((e) => e.id == id);
    await saveYaruKoto(list);
  }
}
