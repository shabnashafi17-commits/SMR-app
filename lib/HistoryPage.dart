import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'MainProvider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _currentAudio;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();

    // fetch latest completed tasks (newest on top)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MainProvider>(context, listen: false)
          .fetchCompletedTasks();
    });
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _playAudio(String filePath) async {
    if (!File(filePath).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio file not found!')),
      );
      return;
    }

    // stop same audio
    if (_currentAudio == filePath) {
      await _player.stopPlayer();
      setState(() => _currentAudio = null);
      return;
    }

    // stop previous audio
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


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(
      context,
      listen: true,
    );
    final tasks = provider.completedTasks.reversed.toList();

// Count total voice tasks
    int remainingVoiceCount = tasks.where((t) => t.taskVoice != null).length;

// Generate voice numbers list (same length as tasks)
    List<int> voiceNumbers = tasks.map((t) {
      if (t.taskVoice != null) {
        return remainingVoiceCount--;
      } else {
        return 0;
      }
    }).toList();


    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
      body: Consumer<MainProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: width / 19),
            itemCount: provider.completedTasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final voiceCount = voiceNumbers[index];




              return Container(
                margin: EdgeInsets.only(bottom: height / 40),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: width / 8,
                              height: height / 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE7DD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                task.taskType == 'voice'
                                    ? Icons.mic_none_outlined
                                    : Icons.checklist,
                                color: const Color(0xFFFF894D),
                              ),
                            ),
                            SizedBox(width: width / 30),
                            Expanded(
                              child: Text(
                                task.taskVoice != null
                                    ? "Voice - $voiceCount"
                                    : task.taskText ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),


                            if (task.taskType == 'voice' &&
                                task.taskVoice != null)
                              IconButton(
                                iconSize: 32,
                                icon: Icon(
                                  _currentAudio == task.taskVoice
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                  color: const Color(0xff0376FA),
                                ),
                                onPressed: () =>
                                    _playAudio(task.taskVoice!),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 13, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (task.date != null)
                            Text(
                              DateFormat("dd/MM/yyyy").format(task.date!),
                              style:
                              const TextStyle(color: Colors.black54),
                            ),
                          const SizedBox(width: 6),
                          if (task.time != null)
                            Text(
                              DateFormat("hh:mm a")
                                  .format(DateTime(0).add(task.time!)),
                              style:
                              const TextStyle(color: Colors.black54),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
