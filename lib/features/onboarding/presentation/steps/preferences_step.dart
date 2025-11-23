import 'package:flutter/material.dart';

typedef OnPrefsChanged = void Function(List<String> selectedQuestionTypes, String generator);

class PreferencesStep extends StatefulWidget {
  final OnPrefsChanged onChanged;
  final List<String> initialTypes;
  final String initialGenerator;

  const PreferencesStep({super.key, required this.onChanged, this.initialTypes = const [], this.initialGenerator = 'sdg-gpt'});

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  final availableTypes = ['Budget advice', 'Expense categorization', 'Savings tips'];
  List<String> selected = [];
  String generator = 'sdg-gpt';

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.initialTypes);
    generator = widget.initialGenerator;
  }

  void _toggleType(String t) {
    setState(() {
      if (selected.contains(t)) {
        selected.remove(t);
      } else {
        selected.add(t);
      }
      widget.onChanged(selected, generator);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Choose question types', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
  ...availableTypes.map((t) => CheckboxListTile(value: selected.contains(t), title: Text(t), onChanged: (_) => _toggleType(t))),
      const SizedBox(height: 12),
      const Text('IA Generator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      DropdownButton<String>(
        value: generator,
        items: const [
          DropdownMenuItem(value: 'sdg-gpt', child: Text('SDG-GPT')),
          DropdownMenuItem(value: 'fast-gen', child: Text('FastGen'))
        ],
        onChanged: (v) {
          if (v != null) {
            setState(() {
              generator = v;
              widget.onChanged(selected, generator);
            });
          }
        },
      ),
    ]);
  }
}
