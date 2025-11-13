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
        title: const Text(
          "Task Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => Navigator.of(context).maybePop(),
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
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // white background
                      labelText: " Date",
                      labelStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(CupertinoIcons.calendar_today, color: Colors.black54),
                      border: InputBorder.none, // removes border
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

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
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // white background
                      labelText: " Time",
                      labelStyle: const TextStyle(color: Colors.black54,fontWeight: FontWeight.bold ),
                      suffixIcon: const Icon(Icons.access_time, color: Colors.black54),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
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
            SizedBox(
              height: 15,
            ),
        Container(
          height: 60,
          width: 350,
          decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(20),),
          child:  Padding(
            padding: const EdgeInsets.only(left: 10,top: 5),
            child: Row(
              children: [
                Text(
                  "Reminder",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 140,),
                Text(
                  "1hr Before",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(width: 10), // Space between text and arrow
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black38,
                  size: 30,
                ),

              ],
            ),
          ),
        ),
            SizedBox(height: 15,),
            const Text(
              "Subtask",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                color: Colors.black38,),
                  borderRadius: BorderRadius.circular(5),// Border color
                           // Border width
              ),
                child:  Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Tomorrow Meeting With Client",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 40,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                              color: Colors.blue,
                              iconSize: 25,
                              onPressed: () {
                                // Action to add a person
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black38,),
                borderRadius: BorderRadius.circular(5),// Border color
                // Border width
              ),

             child:  Padding(
               padding: const EdgeInsets.only(left: 15),
               child: Row(
                 children: [
                   Text(
                      "Take Meeting Notes",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                   SizedBox(width: 110,),
                   Padding(
                     padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                     child: Container(
                       height: 50,
                       width: 50,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.blue, width: 1),
                       ),
                       child: Center(
                         child: IconButton(
                           icon: const Icon(Icons.person_add_alt_1_outlined),
                           color: Colors.blue,
                           iconSize: 25,
                           onPressed: () {
                             // Action to add a person
                           },
                         ),
                       ),
                     ),
                   ),
                 ],
                   ),
             )
             ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black38,),
                borderRadius: BorderRadius.circular(5),// Border color
                // Border width
              ),
                child:  Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Take Meeting Notes",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 110,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                              color: Colors.blue,
                              iconSize: 25,
                              onPressed: () {
                                // Action to add a person
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Container(

            decoration: BoxDecoration(

              border: Border.all(
                color: Colors.blue,),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Add Icon
                  Container(
                    height: 35,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.blue,
                      iconSize: 20,
                      onPressed: () {
                        // Action when pressed
                      },
                    ),
                  ),
                  const SizedBox(height: 15), // Space between icon and text
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]
    )
      ),
      );

  }
}






