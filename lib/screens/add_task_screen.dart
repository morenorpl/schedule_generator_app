import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _durationController = TextEditingController(
      text: widget.taskToEdit?.duration.toString() ?? '',
    );
    if (widget.taskToEdit != null) {
      _selectedDate = widget.taskToEdit!.date;
      // Parse time if it exists
      // For simplicity, we keep current time if parsing fails or just stick to defaults
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit == null ? "Add New Task" : "Edit Task"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Task Name",
                      hintText: "e.g. Halaqah Pagi",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duration (minutes)",
                      hintText: "60",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Date",
                            ),
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(_selectedDate),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() => _selectedTime = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Time",
                            ),
                            child: Text(_selectedTime.format(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: Text(
                        widget.taskToEdit == null ? "Add Task" : "Update Task",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final task = Task(
      id: widget.taskToEdit?.id,
      title: _titleController.text,
      duration: int.tryParse(_durationController.text) ?? 30,
      date: _selectedDate,
      time: _selectedTime.format(context),
    );

    final provider = Provider.of<TaskProvider>(context, listen: false);
    if (widget.taskToEdit == null) {
      provider.addTask(task);
    } else {
      provider.updateTask(task);
    }

    Navigator.pop(context);
  }
}
