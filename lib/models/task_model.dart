
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String title;
  int duration; // in minutes
  DateTime date;
  String? time; // Optional time string e.g., "1:51 PM"
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    required this.duration,
    required this.date,
    this.time,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'date': date.toIso8601String(),
      'time': time,
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    int? duration,
    DateTime? date,
    String? time,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
