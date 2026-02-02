
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class StorageService {
  static const String keyTasks = 'tasks';
  static const String keyUser = 'user';
  static const String keySummary = 'last_summary';
  static const String keyScheduleTitle = 'last_schedule_title';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(keyTasks, data);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(keyTasks);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> saveUser(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUser, nickname);
  }

  Future<String?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUser);
  }
  
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUser);
  }

  // Save last generated summary to avoid keeping it in memory only
  Future<void> saveSummary(String summary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySummary, summary);
  }

  Future<String?> loadSummary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySummary);
  }

  Future<void> saveScheduleTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyScheduleTitle, title);
  }

  Future<String?> loadScheduleTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyScheduleTitle);
  }
}
