import 'package:flutter/material.dart';

class PasswordSaver extends StatefulWidget {
  final Function setPage;

  const PasswordSaver({super.key, required this.setPage});

  @override
  State<PasswordSaver> createState() => _PasswordSaverState();
}

class _PasswordSaverState extends State<PasswordSaver> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Password Saver')
    );
  }
}