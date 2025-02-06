import 'package:flutter/material.dart';

class EstimatedDeliveryTimeInput extends StatefulWidget {
  @override
  _EstimatedDeliveryTimeInputState createState() => _EstimatedDeliveryTimeInputState();
}

class _EstimatedDeliveryTimeInputState extends State<EstimatedDeliveryTimeInput> {
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Estimated Delivery Time',
            suffixIcon: Icon(Icons.timer),
          ),
          controller: TextEditingController(text: _time.format(context)),
        ),
      ),
    );
  }
}