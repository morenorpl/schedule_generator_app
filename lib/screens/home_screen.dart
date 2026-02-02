
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import 'add_task_screen.dart';
import 'summary_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showDeleteConfirmation(BuildContext context, TaskProvider taskProvider, Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              taskProvider.deleteTask(task.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${task.title}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final taskProvider = Provider.of<TaskProvider>(context);

    // Filter tasks if needed, currently showing all
    final tasks = taskProvider.tasks;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $user!",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "Having trouble in your schedule?",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 24),

              // Set Your Schedule Card
              GradientCard(
                colors: const [AppTheme.primaryColor, AppTheme.secondaryColor],
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Set Your Schedule",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Generate your task and be productive!",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).scale(),
              const SizedBox(height: 24),

              // Recent Schedule / Summary Card
              Text(
                "Recent Schedule",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 16),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SummaryScreen()),
                  );
                },
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black, // Placeholder for image
                    borderRadius: BorderRadius.circular(20),
                     image: const DecorationImage(
                      // Using a network image as a placeholder or a gradient if offline
                      image: NetworkImage("https://images.unsplash.com/photo-1535905557558-afc4877a26fc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"),
                      fit: BoxFit.cover,
                      opacity: 0.6,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              taskProvider.scheduleTitle,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              "Click to view generated results",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                         bottom: 20,
                         right: 20,
                         child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).shimmer(duration: 1.seconds),
              const SizedBox(height: 24),

              // Task List Header
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task List",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                      );
                    },
                    child: const Text("See All"),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),

              // Task Items
              if (tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text("No tasks yet. Add one above!"),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        taskProvider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task deleted')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                            child: const Icon(Icons.task_alt, color: AppTheme.secondaryColor),
                          ),
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${task.duration} minutes | ${task.date.toString().split(' ')[0]} ${task.time ?? ''}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => AddTaskScreen(taskToEdit: task)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmation(context, taskProvider, task);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddTaskScreen(taskToEdit: task)),
                            );
                          },
                        ),
                      ),
                    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
