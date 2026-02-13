import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/widget/snackbar.dart';

Future<void> showDateSelectionDialog(
  BuildContext context,
  String title,
  String imageUrl,
) async {
  DateTime? startDate;
  DateTime? endDate;

  final dateFormat = DateFormat('dd MMM yyyy');

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Select Start and End Dates',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Date
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        startDate = pickedDate;
                        if (endDate != null && endDate!.isBefore(startDate!)) {
                          endDate = null;
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate != null
                              ? dateFormat.format(startDate!)
                              : 'Select Start Date',
                          style: TextStyle(
                            color: startDate != null
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? (startDate ?? DateTime.now()),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endDate != null
                              ? dateFormat.format(endDate!)
                              : 'Select End Date',
                          style: TextStyle(
                            color: endDate != null
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (startDate != null && endDate != null) {
                    final prefs = await SharedPreferences.getInstance();
                    List<String> trips =
                        prefs.getStringList('my_itinerary') ?? [];

                    Map<String, String> tripData = {
                      'title': title,
                      'imageUrl': imageUrl,
                      'startDate': dateFormat.format(startDate!),
                      'endDate': dateFormat.format(endDate!),
                    };

                    trips.add(tripData.toString());
                    await prefs.setStringList('my_itinerary', trips);

                    Navigator.pop(context);

                    TopSnackBar.show(
                      context,
                      message: 'Added to Itinerary!',
                      backgroundColor: Colors.green,
                      icon: Icons.check_circle_outline,
                    );
                  } else {
                    TopSnackBar.show(
                      context,
                      message: 'Please select both start and end dates',
                      backgroundColor: Colors.red,
                      icon: Icons.error_outline,
                    );
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
