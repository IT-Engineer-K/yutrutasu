import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/yaru_koto.dart';

class YaruKotoService {
  static const String _key = 'yaru_koto_list';

  /// 全てのプロジェクトを取得
  Future<List<YaruKoto>> getAllYaruKoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      
      if (jsonString == null || jsonString.isEmpty) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) {
            try {
              return YaruKoto.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              if (kDebugMode) debugPrint('Error parsing YaruKoto: $e');
              return null;
            }
          })
          .where((item) => item != null)
          .cast<YaruKoto>()
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading YaruKoto list: $e');
      return [];
    }
  }

  /// プロジェクトを保存
  Future<void> saveYaruKoto(List<YaruKoto> yaruKotoList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(yaruKotoList.map((e) => e.toJson()).toList());
      await prefs.setString(_key, jsonString);
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving YaruKoto list: $e');
      rethrow;
    }
  }

  /// 新しいプロジェクトを追加
  Future<void> addYaruKoto(YaruKoto yaruKoto) async {
    try {
      final list = await getAllYaruKoto();
      list.add(yaruKoto);
      await saveYaruKoto(list);
    } catch (e) {
      if (kDebugMode) debugPrint('Error adding YaruKoto: $e');
      rethrow;
    }
  }

  /// プロジェクトを更新
  Future<void> updateYaruKoto(YaruKoto updatedYaruKoto) async {
    try {
      final list = await getAllYaruKoto();
      final index = list.indexWhere((e) => e.id == updatedYaruKoto.id);
      if (index != -1) {
        list[index] = updatedYaruKoto;
        await saveYaruKoto(list);
      } else {
        throw Exception('YaruKoto with id ${updatedYaruKoto.id} not found');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating YaruKoto: $e');
      rethrow;
    }
  }

  /// プロジェクトを削除
  Future<void> deleteYaruKoto(String id) async {
    try {
      final list = await getAllYaruKoto();
      final initialLength = list.length;
      list.removeWhere((e) => e.id == id);
      if (list.length == initialLength) {
        throw Exception('YaruKoto with id $id not found');
      }
      await saveYaruKoto(list);
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting YaruKoto: $e');
      rethrow;
    }
  }
}
