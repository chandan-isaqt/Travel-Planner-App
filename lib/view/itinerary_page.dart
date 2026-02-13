import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItineraryPage extends StatefulWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String imageUrl;

  const ItineraryPage({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  late DateTime startDate;
  late DateTime endDate;
  late List<DateTime> dateRange;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '12:00 PM';
  String selectedActivity = 'Transport';
  List<Map<String, String>> addedActivities = [];

  @override
  void initState() {
    super.initState();

    startDate = DateFormat('dd MMM yyyy').parse(widget.startDate);
    endDate = DateFormat('dd MMM yyyy').parse(widget.endDate);

    dateRange = List.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => startDate.add(Duration(days: index)),
    );
    loadActivities();
  }

  void loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activityData = prefs.getStringList(widget.title) ?? [];
    setState(() {
      addedActivities = activityData
          .map(
            (e) => Map<String, String>.from({
              'activity': e.split('|')[0],
              'date': e.split('|')[1],
              'time': e.split('|')[2],
            }),
          )
          .toList();
    });
  }

  void saveActivity(Map<String, String> activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activityData = prefs.getStringList(widget.title) ?? [];
    activityData.add(
      '${activity['activity']}|${activity['date']}|${activity['time']}',
    );
    await prefs.setStringList(widget.title, activityData);
    loadActivities();
  }

  Future<void> showActivityDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Add Activity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF00B4D8),
                    ),
                    onTap: () async {
                      final DateTime initialDate =
                          selectedDate.isBefore(startDate)
                          ? startDate
                          : selectedDate;

                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: startDate,
                        lastDate: endDate,
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Time: $selectedTime',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    trailing: const Icon(
                      Icons.access_time,
                      color: Color(0xFF00B4D8),
                    ),
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedActivity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedActivity = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: <String>['Transport', 'Food', 'Sights']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 16)),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                final activity = {
                  'activity': selectedActivity,
                  'date': DateFormat('dd MMM yyyy').format(selectedDate),
                  'time': selectedTime,
                };
                saveActivity(activity);
                Navigator.pop(context);
              },
              child: Text(
                'Add Activity',
                style: TextStyle(color: Color(0xFF00B4D8)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.startDate} - ${widget.endDate}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: addedActivities.length,
        itemBuilder: (context, index) {
          final activity = addedActivities[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            shadowColor: Colors.grey.withOpacity(0.1),
            color: const Color.fromARGB(52, 223, 223, 223),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                    )
                  else
                    Icon(Icons.photo_outlined, size: 60, color: Colors.grey),
                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${activity['activity']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activity['date']} at ${activity['time']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showActivityDialog,
        backgroundColor: const Color(0xFF00B4D8),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
