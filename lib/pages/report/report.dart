import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Report Page"),
        ElevatedButton(
          child: const Text("Go Back"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
