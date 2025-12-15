import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/MainProvider.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch completed tasks after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MainProvider>(context, listen: false);
      provider.fetchHistory(); // ✅ Fetch completed tasks
    });
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

        final history = provider.historyList;


    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
      ),

      body: provider.isHistoryLoading
    ? const Center(child: CircularProgressIndicator())
        : history.isEmpty
    ? const Center(
    child: Text(
    "No completed tasks found",
    style: TextStyle(fontSize: 16, color: Colors.black54),
    ),
    )
    :ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 19, vertical: 16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final task = history[index];

          // Combine date & time
          String displayDateTime = "Not Scheduled";
          if (task.date != null && task.time != null) {
            final combined = DateTime(
              task.date!.year,
              task.date!.month,
              task.date!.day,
              task.time!.inHours,
              task.time!.inMinutes.remainder(60),
            );
            int hour = combined.hour;
            final minute = combined.minute.toString().padLeft(2, '0');
            final ampm = hour >= 12 ? "PM" : "AM";
            if (hour == 0) hour = 12;
            if (hour > 12) hour -= 12;

            displayDateTime =
            "${combined.day.toString().padLeft(2, '0')}/"
                "${combined.month.toString().padLeft(2, '0')}/"
                "${combined.year}  ${hour.toString().padLeft(2, '0')}:$minute $ampm";
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
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
                 child:  Row(
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
                              task.taskText ?? "Voice Task",
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

                      // Voice Task
                      if (task.taskVoice != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.mic_none_outlined, color: Color(0xFFFE6B2C)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Voice Reminder",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                              // Optional: play button for audio
                              IconButton(
                                onPressed: () {
                                  // TODO: Play audio from task.taskVoice
                                },
                                icon: const Icon(Icons.play_arrow, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                    ],
                  ),
              )

              ),
                  Padding(
                    padding: const EdgeInsets.only(left: 140,top: 7),
                    child: Text(
                      displayDateTime,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
            ]
              ),
            ),
          );
        },
      ),

    );
  }
}
