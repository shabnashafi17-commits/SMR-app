import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/HistoryPage.dart';
import 'package:smr_app/MainProvider.dart';
import 'package:smr_app/TaskDetailsPage.dart';
import 'package:lottie/lottie.dart';

import 'contact_asign.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  // Audio - recorder & player
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecording = false;
  String? _currentAudio; // which audio path is currently playing
  String? _filePath; // last recorded file path

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initAudio());
  }


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
    if (_recorder.isRecording) return;      // FIX
    final dir = await getApplicationDocumentsDirectory();
    _filePath =
    '${dir.path}/reminder_record_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacADTS,
    );

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Audio file not found!')));
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



  Widget _buildBottomInputBar(double height, double width,MainProvider provider) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 6),
            ),
          ],
        ),
        height: height * 100 / 932,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Enter Your Task",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),

            Positioned(
              right: 0,
              bottom: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: _focusNode.hasFocus ? Colors.green : const Color(0xff074899),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(_focusNode.hasFocus ? Icons.add : Icons.mic, color: Colors.white),
                  onPressed: () async {
                    if (_focusNode.hasFocus) {
                      _saveReminder(provider);
                      _focusNode.unfocus();
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setStateSheet) {
                              return TokenBottomSheet(
                                startRecording: () async {
                                  await _startRecording();
                                  setState(() {});
                                  setStateSheet(() {});
                                },
                                stopRecording: () async {
                                  if (_isRecording) {
                                    await _stopRecording(provider);
                                  }
                                  setState(() {});
                                  setStateSheet(() {});
                                },
                                isRecording: _isRecording,
                              );
                            },
                          );

                        },
                      );
                    }
                  },


                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(double width, double height,
      {required color, required int count, required String label, required String assetPath}) {
    return Container(
      width: width / 2.3,
      height: height/ 7.5,
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
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
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ],
          ),
          Text(label, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context, listen: true); // listen to changes
    final reminders = provider.reminders;


    final todayCount = reminders.where((r) {
      final now = DateTime.now();
      final c = r.createdAt;
      return c.year == now.year && c.month == now.month && c.day == now.day;
    }).length;

    List<int> voiceNumbers = [];
    int count = 0;
    for (var r in reminders) {
      if (r.taskVoice!= null) {
        count++;
        voiceNumbers.add(count);
      } else {
        voiceNumbers.add(0);
      }
    }

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
                  child: Image.asset("assets/Frame6.png", width: 20, height: 20, fit: BoxFit.contain),
                ),
                SizedBox(width: width / 40),
                const Text("Hi, Nihal", style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ContactAsign(),)
                      );
                    },
                    child: Text("Add",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.black
                      ),
                    )
                )
              ],
            ),
          ),
          SizedBox(height: height / 22),

          // Stats cards
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
                _buildStatCard(width, height, count: reminders.length, label: 'Total', assetPath: "assets/Frame5.png", color: const Color(0xff00B9D6)),
              ],
            ),
          ),

          SizedBox(height: height / 35),

          // Tasks Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 19),
            child: Row(
              children: [
                const Text("Tasks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                  },
                  child: Container(
                    height: width / 8,
                    width: width / 3.5,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: const Color(0xffEDEDED)),
                    child: const Center(child: Text("History", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18))),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: height / 40),

          // Reminder list
          Expanded(
              child: reminders.isEmpty
                  ? const Center(child: Text("No tasks found"))
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: width / 19),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  int voiceCount = voiceNumbers[index]; // ✅ This is correct

                  return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Taskdetailspage())),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          width: width / 10,
                          height: height / 20,
                          decoration: BoxDecoration(color: const Color(0xFFFFE7DD), borderRadius: BorderRadius.circular(12)),
                          child: Icon(
                            reminder.taskVoice != null ? Icons.mic_none_outlined : Icons.checklist,
                            size: 24,
                            color: const Color(0xFFFE6B2C),
                          ),
                        ),
                        SizedBox(width: width / 25),
                        Expanded(
                          child: reminder.taskVoice!= null
                              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Voice - $voiceCount", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey)),
                          ])
                              : Text(reminder.taskText?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey)),
                        ),

                        // Play button for voice reminders
                        if (reminder.taskVoice != null)
                          IconButton(
                            iconSize: 32,
                            icon: Icon(_currentAudio == reminder.taskVoice ? Icons.stop : Icons.play_arrow, color: Colors.blueAccent),
                            onPressed: () => _playAudio(reminder.taskVoice!),
                          ),

                        // Group add button (left as original)
                        InkWell(
                          onTap: () {
                            if (isCheckedList.length != Contactlist.length) {
                              isCheckedList = List.generate(Contactlist.length, (_) => false);
                            }
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
                                        padding: EdgeInsets.only(top: height / 22, left: width / 30, bottom: height / 35),
                                        child: Row(
                                          children: [
                                            const Text("Contact List", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: SizedBox(
                                                height: height / 25,
                                                width: width / 6,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
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
                                        height: halfScreenHeight - 60,
                                        child: ListView.builder(
                                          itemCount: Contactlist.length,
                                          itemBuilder: (context, cIndex) {
                                            final item = Contactlist[cIndex];
                                            return Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                              margin: const EdgeInsets.all(8),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset("assets/Frame6.png",scale: 3,),
                                                    const SizedBox(width: 16),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                        const SizedBox(height: 4),
                                                        Text("${item["number"]}"),

                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    StatefulBuilder(builder: (context, setState) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isCheckedList[cIndex] = !isCheckedList[cIndex];
                                                          });
                                                        },
                                                        child: Icon(
                                                          isCheckedList[cIndex] ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                                                          color: Colors.black,
                                                        ),
                                                      );
                                                    }),
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
                              },
                            );
                          },
                          child: Container(
                            width: width / 10,
                            height: height / 20,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                            child: const Icon(Icons.group_add_outlined, color: Colors.white),
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

      // Bottom input bar
      bottomNavigationBar: _buildBottomInputBar(height, width,provider),
    );
  }
}





class TokenBottomSheet extends StatelessWidget {
  final Future<void> Function() startRecording;
  final Future<void> Function() stopRecording;
  final bool isRecording;

  const TokenBottomSheet({
    super.key,
    required this.startRecording,
    required this.stopRecording,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: h * 0.12,
              child: isRecording
                  ? Transform.scale(scale: 2.5, child: Lottie.asset('assets/audio_wave.json'))
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (isRecording) {
                    await stopRecording();
                    if (context.mounted) Navigator.pop(context);
                  } else {
                    await startRecording();
                  }
                },
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    isRecording ? 'assets/Frame8.png' : 'assets/Frame7.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isRecording ? "Recording..." : "Speak your task",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}