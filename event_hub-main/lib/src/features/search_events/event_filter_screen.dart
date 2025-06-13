import 'package:event_hub/src/configs/components/custom_drop_down.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';

class EventFilterScreen extends StatefulWidget {
  const EventFilterScreen({super.key});

  @override
  State<EventFilterScreen> createState() => _EventFilterScreenState();
}

class _EventFilterScreenState extends State<EventFilterScreen> {
  EventCategory? _selectedCategory;
  EventType? _selectedType;
  bool? _isPaid;
  DateTime? _selectedStartDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Events")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomDropdown<EventCategory>(
              'Category',
              _selectedCategory ?? EventCategory.values.first,
              EventCategory.values,
              (val) => setState(() => _selectedCategory = val),
            ),
            SizedBox(height: 15),
            CustomDropdown<EventType>(
              'Type',
              _selectedType ?? EventType.values.first,
              EventType.values,
              (val) => setState(() => _selectedType = val),
            ),
            SizedBox(height: 15),
            CustomDropdown<bool>('Is Paid', _isPaid ?? true, const [
              true,
              false,
            ], (val) => setState(() => _isPaid = val)),
            SizedBox(height: 15),
            ListTile(
              title: Text(
                _selectedStartDate != null
                    ? "Start Date: ${_selectedStartDate!.toLocal().toString().split(' ')[0]}"
                    : "Pick Start Date",
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _selectedStartDate = picked);
                }
              },
            ),
            const Spacer(),
            RoundButton(
              title: "Apply Filter",
              onPress: () {
                final filter = EventFilter(
                  category: _selectedCategory,
                  type: _selectedType,
                  isPaid: _isPaid,
                  startDate: _selectedStartDate,
                );
                Navigator.pop(context, filter);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EventFilter {
  final EventCategory? category;
  final EventType? type;
  final bool? isPaid;
  final DateTime? startDate;

  EventFilter({this.category, this.type, this.isPaid, this.startDate});
}
