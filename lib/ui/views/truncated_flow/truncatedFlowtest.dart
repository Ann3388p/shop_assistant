import 'package:flutter/material.dart';


class CheckboxListDemo extends StatefulWidget {
  @override
  _CheckboxListDemoState createState() => _CheckboxListDemoState();
}

class _CheckboxListDemoState extends State<CheckboxListDemo> {
  List<bool> _checkboxValues = List.generate(5, (index) => true);
  List<Color> _cardColors = List.generate(5, (index) => Colors.lightGreen);

  void _handleCheckboxChange(int index) {
    setState(() {
      _checkboxValues[index] = !_checkboxValues[index];
      _cardColors[index] =
      _checkboxValues[index] ? Colors.lightGreen : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkbox List Demo')),
      body: ListView.builder(
        itemCount: _checkboxValues.length,
        itemBuilder: (context, index) {
          return Card(
            color: _cardColors[index],
            child: ListTile(
              title: Text('Item $index'),
              leading: Checkbox(
                value: _checkboxValues[index],
                onChanged: (value) {
                  _handleCheckboxChange(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
