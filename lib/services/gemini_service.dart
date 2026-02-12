import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';

class GeminiService {
  // TODO: Replace with your actual API key or use --dart-define

  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  late final GenerativeModel _model;

  GeminiService() {
    log('API KEY : $_apiKey');
    _model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: _apiKey);
  }

  Future<String> generateSchedule(List<Task> tasks, String userName) async {
    if (tasks.isEmpty) {
      return "You have no tasks to schedule! creative freedom is yours.";
    }

    final taskDescriptions = tasks
        .map(
          (t) =>
              "- ${t.title} (${t.duration} mins) [Due: ${t.date.toString().split(' ')[0]} ${t.time ?? ''}]",
        )
        .join('\n');

    final prompt =
        '''
    Hello Gemini, I am $userName. Here is my list of tasks for the day:
    $taskDescriptions

    Please generate an optimal daily schedule for me. 
    1. Organize them logically.
    2. Prioritize based on deadlines if any.
    3. Suggest break times.
    4. Provide a motivating summary or quote.
    
    Format the output in Markdown. Make it encouraging and productive.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ??
          "Sorry, I couldn't generate a schedule at this time.";
    } catch (e) {
      return "Error generating schedule: $e. Please check your API Key.";
    }
  }
}
