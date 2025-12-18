import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/MainProvider.dart';
import 'package:table_calendar/table_calendar.dart';

class Taskdetailspage extends StatelessWidget {
  final Reminder reminder;
  final String? taskText;
  final String? taskVoice;
  final int index;
    const Taskdetailspage({super.key,this.taskText,this.taskVoice,required this.reminder,required this.index});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context, listen: true);
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
              padding: const EdgeInsets.only(left: 20),
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
                  onPressed: () async {
                    provider.fetchReminders();
                    // First, check the task status from Firestore
                    final taskDoc = await FirebaseFirestore.instance
                        .collection("Tasks")
                        .doc(reminder.id)
                        .get();

                    final taskStatus = taskDoc.data()?['taskStatus'];

                    if (taskStatus == "completed") {
                      // Show "already finished" alert
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Task Already Finished',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          content: const Text(
                            'This task is already finished.',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Color(0xff0376FA),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 6,
                                shadowColor: Colors.black26,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "OK",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                      return; // Stop further execution
                    }

                    // If not completed, show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          'Complete Task',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        content: const Text(
                          'Do you want to complete this task?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          // No button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                              shadowColor: Colors.black26,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "No",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 15),

                          // Yes button
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff0376FA),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              Navigator.pop(context); // Close "Complete Task" alert
                              await provider.completeTask(reminder,index);
provider.fetchReminders();
                              showDialog(
                                context: context,
                                barrierDismissible: false, // prevent manual dismissal
                                builder: (ctx2) {
                                  // Close dialog automatically after 2 seconds
                                  Future.delayed( Duration(seconds: 1), () {
                                    if (Navigator.canPop(ctx2)) Navigator.pop(ctx2);
                                  });

                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      width: screenWidth,
                                      height: screenHeight * 176 / 932,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(21),
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.checkmark_alt_circle_fill,
                                            size: 39,
                                            color: const Color(0xFF00BA25),
                                          ),
                                          SizedBox(height: screenHeight * 16 / 932),
                                          const Text(
                                            'Task Completed',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF1F2937),
                                              fontFamily: 'Intel',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF038D1F),
                    minimumSize: const Size(68, 31),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],

          ),
        ),
      ),
        body: SafeArea(
        child: SingleChildScrollView(
        reverse: true,
         child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Column(
                children: [
                  // --------- LARGER TEXT TASK CONTAINER ---------
                  if (taskVoice == null)
                    Container(
                      height: screenHeight * 110 / 932,
                      width: screenWidth * 384 / 430,
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
                              width: screenWidth * 360 / 430,
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
                                      onPressed: ()async {
                                        print("dfkjhjvjhd");
                                        await provider.fetchContacts();
                                        // if (isCheckedList.length != Contactlist.length) {
                                        //   isCheckedList = List.generate(Contactlist.length, (_) => false);
                                        // }
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: const Color(0xffF2F2F2),
                                          builder: (BuildContext context) {
                                            final double halfScreenHeight = MediaQuery.of(context).size.height / 2;
                                            return Container(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(top: screenHeight / 22, left: screenWidth / 30, bottom: screenHeight / 35),
                                                    child: Row(
                                                      children: [
                                                        const Text("Contact List", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                                        const Spacer(),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: SizedBox(
                                                            height: screenHeight / 25,
                                                            width: screenWidth / 6,
                                                            child: ElevatedButton(
                                                              onPressed: () {},
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Color(0xff0376FA),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                                                elevation: 2,
                                                                padding: EdgeInsets.zero,
                                                              ),
                                                              child: const Center(child: Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: halfScreenHeight - 50,
                                                    child: Consumer<MainProvider>(
                                                        builder: (context,provider,child) {
                                                          return ListView.builder(
                                                            itemCount: provider.contactList.length,
                                                            itemBuilder: (context, index) {
                                                              final contact = provider.contactList[index];

                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  color: Colors.white,
                                                                ),
                                                                margin: const EdgeInsets.all(8),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(12.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons.person_outline),
                                                                      SizedBox(width: 16),

                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Name: ${contact.username}",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(height: 4),
                                                                            Text(
                                                                              "Phone: ${contact.userContactNumber}",
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      InkWell(
                                                                        onTap: () => provider.changeAddContact(index),
                                                                        child: Icon(
                                                                          provider.tempCheckedList == index
                                                                              ? Icons.check_box_outlined
                                                                              : Icons.check_box_outline_blank,
                                                                          color: Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );

                                                        }
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                            padding: const EdgeInsets.only(left: 130),
                            child: Consumer<MainProvider>(
                              builder: (context, provider, child) {
                                final current = provider.reminders.firstWhere(
                                      (r) => r.id == reminder.id,
                                );

                                String displayText = "Not Scheduled";

                                if (current.date != null && current.time != null) {
                                  final combined = DateTime(
                                    current.date!.year,
                                    current.date!.month,
                                    current.date!.day,
                                    current.time!.inHours,
                                    current.time!.inMinutes.remainder(60),
                                  );

                                  // Convert to AM/PM
                                  int hour = combined.hour;
                                  final minute = combined.minute.toString().padLeft(2, '0');
                                  final ampm = hour >= 12 ? "PM" : "AM";
                                  if (hour == 0) hour = 12;
                                  if (hour > 12) hour -= 12;

                                  displayText =
                                  "${combined.day.toString().padLeft(2, '0')}/"
                                      "${combined.month.toString().padLeft(2, '0')}/"
                                      "${combined.year}  "
                                      "${hour.toString().padLeft(2, '0')}:$minute $ampm";
                                }

                                return Text(
                                  displayText,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4B5563),
                                  ),
                                );
                              },
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
                child: Container(
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

                      SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: DatePickerContainer(reminderId: reminder.id)),
                          SizedBox(width: 12),
                          Expanded(child: TimePickerContainer(reminderId: reminder.id)),
                        ],
                      ),


                      SizedBox(height: 15),

                      // Reminder container
                      Container(
                        height: 60,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Reminder", style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showReminderDialog(
                                    context,
                                    provider.selectedReminder, // ← ALWAYS use provider value
                                  );

                                  if (picked != null) {
                                    provider.setSelectedReminder(picked);
                                  }
                                },



                                child: Row(
                                  children: [Text(provider.selectedReminder),

                                    SizedBox(width: 7),
                                    Icon(CupertinoIcons.chevron_down, size: 14),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      ReminderSaveButton(reminderId: reminder.id),


    SizedBox(height: 10),
                    ],
                  ),
                ),
              ),


              SubtaskListContainer(reminderId: reminder.id), //

            ]
    )
    )
    )
        )
      );


  }
}

class DatePickerContainer extends StatefulWidget {
  final String reminderId;
  const DatePickerContainer({required this.reminderId, Key? key}) : super(key: key);

  @override
  _DatePickerContainerState createState() => _DatePickerContainerState();
}

class _DatePickerContainerState extends State<DatePickerContainer> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    super.initState();

    final provider = Provider.of<MainProvider>(context, listen: false);
    final reminder = provider.reminders.firstWhere((r) => r.id == widget.reminderId);

    _selectedDate = reminder.date;        // 🔵 LOAD from Firestore
    _focusedDay = reminder.date ?? DateTime.now();
  }


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

              // 🔵 Disable previous dates
              enabledDayPredicate: (day) {
                final today = DateTime.now();
                return !day.isBefore(DateTime(today.year, today.month, today.day));
              },

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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
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
    if (picked != null) {
      setState(() => _selectedDate = picked);

      // 🔵 SAVE DATE TO FIREBASE
      final provider = Provider.of<MainProvider>(context, listen: false);
      provider.updateReminderDate(widget.reminderId, picked);
    }

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
        padding: EdgeInsets.symmetric(horizontal: 9),
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
  final String reminderId;
  const TimePickerContainer({required this.reminderId, Key? key}) : super(key: key);


  @override
  _TimePickerContainerState createState() => _TimePickerContainerState();
}

class _TimePickerContainerState extends State<TimePickerContainer> {
  Duration? _selectedTime;
  @override
  void initState() {
    super.initState();

    final provider = Provider.of<MainProvider>(context, listen: false);
    final reminder = provider.reminders.firstWhere((r) => r.id == widget.reminderId);

    _selectedTime = reminder.time;   // 🔵 LOAD SAVED TIME
  }


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
                      onPressed: () {
                        Navigator.of(ctx).pop();

                        // 🔵 SAVE TIME TO FIREBASE
                        if (_selectedTime != null) {
                          final provider = Provider.of<MainProvider>(context, listen: false);
                          provider.updateReminderTime(widget.reminderId, _selectedTime!);
                        }
                      },

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
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Icon(
                  CupertinoIcons.time,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<String?> showReminderDialog(
    BuildContext context,
    String selectedReminder,
    ) async {
  final List<String> reminderOptions = [
    "No Reminder",
    "5 min Before",
    "10 min Before",
    "30 min Before",
    "1 hr Before",
    "2 hrs Before",
    "1 day Before",
  ];

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Reminder Time"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reminderOptions.length,
            itemBuilder: (context, index) {
              final item = reminderOptions[index];

              return ListTile(
                title: Text(item),
                trailing: item == selectedReminder
                    ? Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  Navigator.pop(context, item);
                },
              );
            },
          ),
        ),
      );
    },
  );
}
class ReminderSaveButton extends StatelessWidget {
  final String reminderId;
  const ReminderSaveButton({required this.reminderId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          // ALWAYS SAVE
          await provider.updateReminderOption(
            reminderId,
            provider.selectedReminder,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xff0376FA),
          side: BorderSide(color: Color(0xff0376FA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text("Save"),
      ),
    );
  }
}



class SubtaskListContainer extends StatefulWidget {
  final String reminderId;
  const SubtaskListContainer({required this.reminderId, Key? key})
      : super(key: key);

  @override
  _SubtaskListContainerState createState() => _SubtaskListContainerState();
}

class _SubtaskListContainerState extends State<SubtaskListContainer> {
  TextEditingController subtaskController = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

     return Consumer<MainProvider>(
        builder: (context, provider, child) {
          final reminder = provider.reminders.firstWhere(
                  (r) => r.id == widget.reminderId
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Subtasks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // Existing subtasks
              if (reminder.subtasks.isNotEmpty)
                ...reminder.subtasks.map((task) =>
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26, width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                task,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xff0376FA), width: 1.5),
                              ),
                              child: const Icon(
                                Icons.group_add_outlined,
                                color: Color(0xff0376FA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

              // Input field
              if (isTyping)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: subtaskController,
                    decoration: InputDecoration(
                      hintText: "Enter Subtask...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.black26, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.black26, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.black45, width: 1.5),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // Add/Save button
              Center(
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton.icon(
                    icon: const Icon(CupertinoIcons.add_circled),
                    label: Text(isTyping ? "Save" : "Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xff0376FA),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                            color: Color(0xff0376FA), width: 1),
                      ),
                    ),
                    onPressed: () async {
                      if (isTyping) {
                        final text = subtaskController.text.trim();
                        if (text.isEmpty) return;

                        // Add subtask in provider and Firestore
                        await provider.addSubtaskToReminder(
                            widget.reminderId, text);

                        // Clear field and close input
                        subtaskController.clear();
                        setState(() {
                          isTyping = false;
                        });
                      } else {
                        setState(() {
                          isTyping = true;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );

  }
}
