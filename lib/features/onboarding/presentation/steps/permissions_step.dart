import 'package:flutter/material.dart';

class PermissionsStep extends StatelessWidget {
  const PermissionsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text('Permissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('We may ask for permissions such as notifications. You can change these later in settings.'),
    ]);
  }
}
