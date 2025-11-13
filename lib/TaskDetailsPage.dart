import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Taskdetailspage extends StatefulWidget {
  const Taskdetailspage({super.key});

  @override
  State<Taskdetailspage> createState() => _TaskdetailspageState();
}

class _TaskdetailspageState extends State<Taskdetailspage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Row(
          children: [
            const Text(
              "Task Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              Navigator.pop(context);

    },

            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Green button pressed!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color(0xFF038D1F),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 22, ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
            const Text(
              "Schedule",
              style: TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                // ---------------- DATE FIELD ----------------
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: " Date",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: const Icon(
                        CupertinoIcons.calendar_today,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      // Default selected date: October 15 if none selected
                      DateTime initialDate = DateTime.now();
                      if (_dateController.text.isNotEmpty) {
                        try {
                          final parts = _dateController.text.split('/');
                          if (parts.length == 3) {
                            initialDate = DateTime(
                              int.parse(parts[2]),
                              int.parse(parts[1]),
                              int.parse(parts[0]),
                            );
                          }
                        } catch (_) {}
                      } else {
                        initialDate =
                            DateTime(DateTime.now().year, 10, 15); // Oct 15
                      }

                      // Show Cupertino (iOS-style) date picker
                      DateTime? pickedDate =
                      await showModalBottomSheet<DateTime>(
                        context: context,
                        builder: (BuildContext builder) {
                          DateTime tempPickedDate = initialDate;

                          return Container(
                            height: 250,
                            color: Color(0xFFFFFFFF),
                            child: Column(
                              children: [
                                // Done button
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: const Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, tempPickedDate);
                                    },
                                  ),
                                ),

                                // Cupertino Date Picker
                                Expanded(
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: initialDate,
                                    minimumDate: DateTime(2000),
                                    maximumDate: DateTime(2101),
                                    onDateTimeChanged: (DateTime newDate) {
                                      tempPickedDate = newDate;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      // Update field
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // ---------------- TIME FIELD ----------------
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      labelText: " Time",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.blue,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedTime != null) {
                        setState(() {
                          _timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // ---------------- REMINDER ----------------
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Reminder",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "1hr Before",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black38,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- SUBTASKS ----------------
            const Text(
              "Subtask",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            _buildSubtaskRow("Tomorrow Meeting With Client"),
            const SizedBox(height: 15),
            _buildSubtaskRow("Take Meeting Notes"),
            const SizedBox(height: 15),
            _buildSubtaskRow("Prepare Presentation Slides"),
            const SizedBox(height: 15),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 35,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.blue,
                          iconSize: 20,
                          onPressed: () {
                            // Add subtask
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HELPER WIDGET ----------------
  Widget _buildSubtaskRow(String text) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  color: Colors.blue,
                  iconSize: 25,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}










