
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _controller = TextEditingController();

  void _login() {
    if (_controller.text.isNotEmpty) {
      Provider.of<AuthService>(context, listen: false).login(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.auto_awesome, size: 60, color: AppTheme.primaryColor)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            Text(
              "Welcome to ScheduleGen",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
            Text(
              "Let's get productive! Enter your name to start.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 48),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Your Nickname",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Get Started"),
            ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0),
          ],
        ),
      ),
    );
  }
}
