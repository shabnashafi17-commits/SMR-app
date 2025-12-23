import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/ADMIN%20SIDE/HistoryPage.dart';
import 'package:smr_app/MainProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:smr_app/USER%20Side/userTaskDetailse.dart';
import '../Splash_Screen.dart';

import '../ADMIN SIDE/contact_asign.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});


  @override
  State<UserHomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<UserHomeScreen> with TickerProviderStateMixin {
  // Controllers / focus
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Example contact & lists (kept from your original)
  List<bool> isCheckedList = [];
  List<Map<String, dynamic>> Contactlist = [
    {"name": "Nihal", "number": 6534546},
    {"name": "Ameen", "number": 9876543},
    {"name": "Nihal", "number": 6534546},
    {"name": "Ameen", "number": 9876543},
    {"name": "Nihal", "number": 6534546},
    {"name": "Ameen", "number": 9876543},
  ];
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<MainProvider>();

      provider.isAssignedMode = true;

      await provider.fetchAssignedTasks("1766469803731");
      super.initState();
      Future.microtask(() => _initAudio());

      provider.notifyListeners();
    });
  }

  // Audio - recorder & player
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecording = false;
  String? _currentAudio; // which audio path is currently playing
  String? _filePath; // last recorded file path


  Future<void> _initAudio() async {
    // Request permissions (best-effort)
    await Permission.microphone.request();
    await Permission.storage.request();

    await _recorder.openRecorder();
    await _player.openPlayer();
    // optional: subscription duration (not required here)
    await _player.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  Future<void> _startRecording() async {
    if (_recorder.isRecording) return; // FIX
    final dir = await getApplicationDocumentsDirectory();
    _filePath =
    '${dir.path}/reminder_record_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording(MainProvider provider) async {
    if (!_recorder.isRecording) return;
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    if (_filePath != null) {
      await provider.addVoiceReminder(_filePath!);
    }
  }

  Future<void> _playAudio(String filePath) async {
    if (!File(filePath).existsSync()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Audio file not found!')));
      return;
    }

    if (_currentAudio == filePath) {
      await _player.stopPlayer();
      setState(() => _currentAudio = null);
      return;
    }
    if (_currentAudio != null) {
      await _player.stopPlayer();
    }

    await _player.startPlayer(
      fromURI: filePath,
      codec: Codec.aacADTS,
      whenFinished: () {
        setState(() => _currentAudio = null);
      },
    );

    setState(() => _currentAudio = filePath);
  }

  void _saveReminder(MainProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await provider.addTextReminder(text);
    _controller.clear();
  }
  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override

  Widget _buildStatCard(
      double width,
      double height, {
        required color,
        required int count,
        required String label,
        required String assetPath,
      }) {
    return Container(
      width: width / 2.3,
      height: height / 7.5,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: width / 9,
                height: height / 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(
      context,
      listen: true,
    ); // listen to changes
    final reminders = provider.reminders;

    final todayCount = reminders.where((r) {
      final now = DateTime.now();
      final c = r.createdAt;
      return c.year == now.year && c.month == now.month && c.day == now.day;
    }).length;

    // Count all voice reminders in the current list
    int totalVoiceCount = reminders.where((r) => r.taskVoice != null).length;

    // Map each reminder to its voice number, if applicable
    List<int> voiceNumbers = reminders.map((r) {
      if (r.taskVoice != null) {
        return totalVoiceCount--;
      }
      return 0;
    }).toList();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF2F2F2),
      body: Column(
        children: [
          SizedBox(height: height / 13),
          Padding(
            padding: EdgeInsets.only(left: width / 30),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Image.asset(
                    "assets/Frame6.png",
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: width / 40),
                const Text(
                  "Hi, Nihal ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),]

            ),

          ),
          SizedBox(height: height / 22),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 24),
            child: Row(
              children: [
                _buildStatCard(
                  width,
                  height,
                  count: todayCount,
                  label: 'Today',
                  assetPath: "assets/Frame3.png",
                  color: const Color(0xffFF6B2C),
                ),

                SizedBox(width: width / 25),
                _buildStatCard(
                  width,
                  height,
                  count: provider.userAssignedTasks.length,
                  label: 'Total',
                  assetPath: "assets/Frame5.png",
                  color: const Color(0xff00B9D6),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 35),

          // Tasks Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 19),
            child: Row(
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                 Spacer(),
                GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    height: width / 8,
                    width: width / 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xffEDEDED),
                    ),
                    child: const Center(
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: height / 40),

          // Reminder list
          Expanded(
            child: Consumer<MainProvider>(
              builder: (context, provider, child) {

                final list = provider.userAssignedTasks;


                return list.isEmpty
                    ? const Center(child: Text("No tasks found"))
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: width / 19),
                  itemCount: list.length, // ✅ FIXED
                  itemBuilder: (context, index) {
                    final reminder = list[index];

                    int voiceCount = 0;
                    if (reminder.taskVoice != null) {
                      voiceCount = index + 1;
                    }

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTaskdetailspage(
                            reminder: reminder,
                            taskText: reminder.taskText,
                            taskVoice: reminder.taskVoice,
                            index: index,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
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
                              child: Icon(
                                reminder.taskVoice != null
                                    ? Icons.mic_none_outlined
                                    : Icons.checklist,
                                size: 24,
                                color: const Color(0xFFFE6B2C),
                              ),
                            ),

                            SizedBox(width: width / 25),

                            Expanded(
                              child: reminder.taskVoice != null
                                  ? Text(
                                "Voice - $voiceCount",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4B5563),
                                ),
                              )
                                  : Text(
                                reminder.taskText ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),

                            if (reminder.taskVoice != null)
                              IconButton(
                                iconSize: 32,
                                icon: Icon(
                                  _currentAudio == reminder.taskVoice
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                  color: const Color(0xff0376FA),
                                ),
                                onPressed: () =>
                                    _playAudio(reminder.taskVoice!),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )


        ],
      ),


    );
  }
}



