import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/MainProvider.dart';
import 'package:table_calendar/table_calendar.dart';

class Taskdetailspage extends StatelessWidget {
  final String? taskText;
  final String? taskVoice;
    const Taskdetailspage({super.key,this.taskText,this.taskVoice,});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context, listen: true); // listen to changes
    final reminders = provider.reminders;
    int voiceCount = reminders.where(
            (r) => r.taskVoice != null && r.taskVoice!.isNotEmpty).length;


    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            title: Text(
              'Task Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0XFF1F2937),
              ),
            ),
            // <-- FIX: wrap InkWell in a Builder so Navigator.pop uses the correct context
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Builder(
                builder: (context) => InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
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
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          width: screenWidth ,
                          height: screenHeight * 176 / 932,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              color: Colors.white),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt_circle_fill,
                                size: 39,
                                color: Color(0xFF00BA25),
                              ),
                              SizedBox(height: screenHeight * 16 / 932),
                              Text(
                                'Task Completed',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF1F2937),
                                    fontFamily: 'Intel'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF038D1F),
                    minimumSize: Size(68, 31),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Column(
                children: [
                  // --------- LARGER TEXT TASK CONTAINER ---------
                  if (taskVoice == null)
                    Container(
                      height: screenHeight * 103 / 932,
                      width: screenWidth * 361 / 430,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x15000000),
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
                            child: Container(
                              height: screenHeight * 60 / 932,
                              width: screenWidth * 350 / 430,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x15000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 36,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFFFE7DD),
                                    ),
                                    child: Icon(
                                      Icons.checklist,
                                      size: 24,
                                      color: Color(0xFFFE6B2C),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        taskText ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4B5563),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF0376FA),
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.group_add_outlined,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 10 / 932),
                          // DATE / TIME for text task
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Your Date & Time",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // --------- SMALL VOICE TASK CONTAINER ---------
                  if (taskVoice != null)
                    Container(
                      height: 60,
                      width: screenWidth * 361 / 430,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x15000000),
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Mic Icon
                          Container(
                            height: 35,
                            width: 36,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFFE7DD),
                            ),
                            child: Icon(
                              Icons.mic_none_outlined,
                              size: 24,
                              color: Color(0xFFFE6B2C),
                            ),
                          ),
                          // Voice Label
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Voice - $voiceCount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ),
                          // Blue Circle Icon
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0376FA),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.group_add_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: screenHeight * 180 / 932,
                  width: screenWidth * 350 / 430,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xEA373636),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 15 / 932),

                      Row(
                        children: [
                          Expanded(child: DatePickerContainer()),
                          SizedBox(width: 12), // spacing
                          Expanded(child: TimePickerContainer()),
                        ],
                      ),

                      SizedBox(height: screenHeight * 15 / 932),

                      //reminder
                      Container(
                        // height:screenHeight* 60/932,
                        width: screenWidth * 400 / 430,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x15000000),
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '1hr Before',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.only(left: 240),
                        child: ElevatedButton(
                          onPressed: () {
                            // your action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // button background
                            side: BorderSide(color: Color(0xff0376FA), width: 1), // blue border
                            foregroundColor: Color(0xff0376FA), // text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // rounded corners
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0376FA), // ensure text is blue
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                    ],
                  ),
                ),
              ),

              SizedBox(height: 40,),
              SubtaskListContainer()
            ],
          ),
        ),
      ),
    );
  }
}

class DatePickerContainer extends StatefulWidget {
  @override
  _DatePickerContainerState createState() => _DatePickerContainerState();
}

class _DatePickerContainerState extends State<DatePickerContainer> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();

  void _pickDate() async {
    DateTime initialDate = _selectedDate ?? DateTime.now();

    DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SizedBox(
            height: 400,
            width: 350,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
                Navigator.of(context).pop(selectedDay);
              },
              calendarFormat: CalendarFormat.month,
              headerVisible: true,
              headerStyle: HeaderStyle(
                titleCentered: false,
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "${_monthName(day.month)} ${day.year}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year,
                                    _focusedDay.month - 1, _focusedDay.day);
                              });
                            },
                          ),
                          IconButton(
                            icon:
                            Icon(Icons.chevron_right, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year,
                                    _focusedDay.month + 1, _focusedDay.day);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                outsideDaysVisible: false,
                selectedDecoration:
                BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 172.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Color(0x15000000), blurRadius: 2, offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                  : 'Date',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_outlined, color: Colors.black),
              onPressed: _pickDate,
            ),
          ],
        ),
      ),
    );
  }
}

class TimePickerContainer extends StatefulWidget {
  @override
  _TimePickerContainerState createState() => _TimePickerContainerState();
}

class _TimePickerContainerState extends State<TimePickerContainer> {
  Duration? _selectedTime;

  void _showTimePicker(BuildContext context) {
    Duration initialTime = _selectedTime ?? Duration(hours: 15, minutes: 0);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  child: CupertinoTimerPicker(
                    initialTimerDuration: initialTime,
                    mode: CupertinoTimerPickerMode.hm,
                    onTimerDurationChanged: (Duration newTime) {
                      setState(() {
                        _selectedTime = newTime;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        shape: StadiumBorder(),
                        backgroundColor: Color(0xff0376FA),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('OK'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final displayText = _selectedTime != null
        ? "${twoDigits(_selectedTime!.inHours)}:${twoDigits(_selectedTime!.inMinutes.remainder(60))}"
        : "Time";

    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        height: 60,
        width: 172.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Icon(
                CupertinoIcons.time,
                size: 22,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubtaskListContainer extends StatefulWidget {
  @override
  _SubtaskListContainerState createState() => _SubtaskListContainerState();
}

class _SubtaskListContainerState extends State<SubtaskListContainer> {
  List<String> subtasks = [
    "Tomorrow Meeting With client",
    "Take Meeting Notes",
    "Take Meeting Notes",
  ];

  void _addSubtask() {
    setState(() {
      subtasks.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Subtask',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subtasks.length,
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    height: 66.531,
                    width: 361,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                            subtasks[index].isNotEmpty ? subtasks[index] : " ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            suffixIcon: Container(
                              height: 34.531,
                              width: 34.531,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border:
                                Border.all(color: Color(0xFF0376FA), width: 1),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.group_add_outlined,
                                    size: 25,
                                    color: Color(0xFF0376FA),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 40, // match ElevatedButton height
              child: FloatingActionButton.extended(
                onPressed: _addSubtask,
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff0376FA),
                elevation: 0, // same as ElevatedButton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // same as ElevatedButton
                  side: BorderSide(color: Color(0xff0376FA), width: 1),
                ),
                icon: Icon(CupertinoIcons.add_circled, size: 24),
                label: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Color(0xff0376FA),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

