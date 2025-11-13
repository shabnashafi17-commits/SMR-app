import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smr_app/TaskDetailsPage.dart'; // your page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isEditing = false;

  List<String> items = [
    "Task 1",
    "Task 2",
    "Task 3",
    "Task 4",
    "Task 5",
    "Task 6",
  ];

  List<Map<String, dynamic>> contactList = [
    {"name": "Nihal", "number": 6534546},
    {"name": "Ameen", "number": 9876543},
    {"name": "Salman", "number": 7654321},
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),

      // ✅ Bottom Navigation Voice/Text Bar
      bottomNavigationBar: _buildBottomInputBar(context, height, width),

      body: Column(
        children: [
          SizedBox(height: height / 13),

          // 🔹 Greeting
          Padding(
            padding: EdgeInsets.only(left: width / 30),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                SizedBox(width: width / 40),
                const Text("Hi, Nihal",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: height / 22),

          // 🔹 Stats Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 24),
            child: Row(
              children: [
                _buildStatCard(
                  width,
                  height,
                  color: const Color(0xFFFF894D),
                  count: items.length,
                  label: 'Today',
                ),
                SizedBox(width: width / 25),
                _buildStatCard(
                  width,
                  height,
                  color: const Color(0xFF4AC4DF),
                  count: items.length,
                  label: 'Total',
                ),
              ],
            ),
          ),
          SizedBox(height: height / 28),

          // 🔹 Tasks Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 19),
            child: Row(
              children: [
                const Text("Tasks",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                const Spacer(),
                Container(
                  height: width / 10,
                  width: width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12,
                  ),
                  child: const Center(
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 25),

          // 🔹 Task List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: width / 19),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Taskdetailspage()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: width / 10,
                          height: height / 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE7DD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.mic_none_outlined,
                              color: Color(0xFFFF894D)),
                        ),
                        SizedBox(width: width / 30),
                        Expanded(
                          child: Text(
                            items[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: width / 10,
                          height: height / 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.group_add_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Input Bar
  Widget _buildBottomInputBar(BuildContext context, double height, double width) {
    return Container(
      height: height * 100 / 932,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: height * 8 / 932,
                bottom: height * 8 / 932,
                left: width * 8 / 430,
              ),
              child: Container(
                height: height * 55 / 932,
                width: width * 344 / 430,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: width * 12 / 430),
                child: Center(
                  child: TextField(
                    controller: _controller,
                    readOnly: !isEditing,
                    onTap: () {
                      if (!isEditing) {
                        setState(() {
                          isEditing = true;
                          _controller.clear();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: isEditing
                          ? 'Tomorrow Meeting with Client'
                          : 'Enter your task',
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (isEditing) {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      items.add(text);
                    });
                  }
                  setState(() {
                    isEditing = false;
                    _controller.clear();
                  });
                } else {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const TokenBottomSheet(),
                  );
                }
              },
              icon: Icon(
                isEditing
                    ? CupertinoIcons.add_circled_solid
                    : CupertinoIcons.mic_circle_fill,
                color: isEditing ? Colors.green : const Color(0xFF1C5F98),
                size: 49,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper for Stat Cards
  Widget _buildStatCard(
      double width,
      double height, {
        required Color color,
        required int count,
        required String label,
      }) {
    return Container(
      width: width / 2.3,
      height: height / 7,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: width / 9,
                height: height / 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Token Bottom Sheet for Mic Recording
class TokenBottomSheet extends StatefulWidget {
  const TokenBottomSheet({super.key});

  @override
  State<TokenBottomSheet> createState() => _TokenBottomSheetState();
}

class _TokenBottomSheetState extends State<TokenBottomSheet>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
    });
    if (isListening) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.3,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 1 / 932),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔊 Animated bar
          SizedBox(
            width: screenWidth * 350 / 430,
            height: screenHeight * 70 / 932,
            child: isListening
                ? Transform.scale(
              scale: 2.5,
              child: Lottie.asset(
                'assets/audio_wave.json',
                repeat: true,
                animate: true,
                fit: BoxFit.contain,
              ),
            )
                : Container(),
          ),
          SizedBox(height: screenHeight * 30 / 932),

          // 🎤 Mic Icon Button
          Container(
            height: screenHeight * 70 / 932,
            width: screenWidth * 70 / 430,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
              isListening ? null : Border.all(color: Colors.grey, width: 1),
            ),
            child: IconButton(
              icon: Icon(
                isListening
                    ? CupertinoIcons.pause_circle_fill
                    : CupertinoIcons.mic_circle_fill,
                color: const Color(0xFF1C5F98),
                size: 49,
              ),
              onPressed: _toggleListening,
            ),
          ),
          SizedBox(height: screenHeight * 35 / 932),

          // 🗣️ Text label
          Text(
            isListening ? 'You are Speaking' : 'Speak Your Task',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


