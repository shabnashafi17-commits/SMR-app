import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<String> items = [
      "Task 1",
      "Task 2",
      "Task 3",
      "Task 4",
      "Task 5",
      "Task 6",
      "Task 7",
      "Task 8",
      "Task 9",
      "Task 10",
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),

      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xffF2F2F2),
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.arrow_back_ios, size: 20),
              ),
            ),
          ),
        ),

        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Container(
              height: height / 22,
              width: width / 3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width / 19),
        itemCount: items.length,
        itemBuilder: (context, index) {
          //date And Time continer
          return Container(
            margin: EdgeInsets.only(bottom: height / 40),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // soft shadow
                  blurRadius: 15, // spread radius
                  offset: Offset(0, 5), // vertical offset
                ),
              ],
            ),
            child: Column(
              children: [
                // Task Continer
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Container(

                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: width / 10,
                          height: height / 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE7DD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.mic_none_outlined,
                            color: Color(0xFFFF894D),
                          ),
                        ),
                        SizedBox(width: width / 30),
                        Expanded(
                          child: Text(
                            items[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("15/10/2020,",
                            style: TextStyle(color: Colors.black54)),
                        Text("10:00 AM",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          );
        },
      ),
    );
  }
}