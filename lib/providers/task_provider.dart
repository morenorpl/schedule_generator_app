
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class TaskProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final GeminiService _geminiService = GeminiService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _generatedSchedule;
  String? _scheduleTitle;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get generatedSchedule => _generatedSchedule;
  String get scheduleTitle => _scheduleTitle ?? "Schedule Title";

  Future<void> loadTasks() async {
    _tasks = await _storageService.loadTasks();
    _generatedSchedule = await _storageService.loadSummary();
    _scheduleTitle = await _storageService.loadScheduleTitle();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> generateSchedule(String userName) async {
    _isLoading = true;
    notifyListeners();

    try {
      _generatedSchedule = await _geminiService.generateSchedule(_tasks, userName);
      await _storageService.saveSummary(_generatedSchedule!);
      
      // Generate dynamic title based on current date/time
      // Needs intl package import if not already present or simple DateTime string
      final now = DateTime.now();
      // Simple formatting to avoid extra dependencies in this file if possible, 
      // but we added intl to pubspec. Let's use it if imported, or just standard check.
      // I will assume simple formatting for now to be safe, or I can import intl.
      // Actually, I can just use a simple robust format.
      final title = "Schedule for ${now.day}/${now.month}/${now.year}";
      _scheduleTitle = title;
      await _storageService.saveScheduleTitle(title);

    } catch (e) {
      _generatedSchedule = "Failed to generate schedule. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
