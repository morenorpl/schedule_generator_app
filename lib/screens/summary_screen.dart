
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final user = Provider.of<AuthService>(context, listen: false).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Result"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               taskProvider.generateSchedule(user ?? "User");
            },
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (taskProvider.generatedSchedule == null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text("No schedule generated yet."),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              taskProvider.generateSchedule(user ?? "User");
                            },
                            child: const Text("Generate with AI"),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: MarkdownBody(
                        data: taskProvider.generatedSchedule!,
                        styleSheet: MarkdownStyleSheet(
                          h1: const TextStyle(color: AppTheme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
                          h2: const TextStyle(color: AppTheme.secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                          p: const TextStyle(fontSize: 16),
                          listBullet: const TextStyle(color: AppTheme.accentColor),
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
    );
  }
}
