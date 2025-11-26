import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        height:screenHeight*100/932,
        width:double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              //  TextField
              Padding(
                padding: EdgeInsets.only(top:screenHeight*8/932, bottom:screenHeight* 8/932, left:screenWidth* 8/430),
                child: Container(
                  height:screenHeight* 55/932,
                  width:screenWidth* 344/430,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:EdgeInsets.symmetric(horizontal:screenWidth*12/430),
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

              //  Icon Button
              IconButton(
                onPressed: () {
                  //add
                  if (isEditing) {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {}

                    setState(() {
                      isEditing = false;
                      _controller.clear();
                    });
                  } else {
                    // mic
                    // showModalBottomSheet(
                    //   context: context,
                    //   builder: (context) => const TokenBottomSheet(),
                    // );
                  }
                },
                icon: Icon(
                  isEditing
                      ? CupertinoIcons.add_circled_solid
                      : CupertinoIcons.mic_circle_fill,

                  color: isEditing
                  ? Colors.green
                  :Color(0xFF1C5F98),
                  size: 49,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TokenBottomSheet extends StatefulWidget {
  final Future<void> Function() startRecording;
  final Future<void> Function() stopRecording;

  const TokenBottomSheet({
    super.key,
    required this.startRecording,
    required this.stopRecording,
  });

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
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));

    _startProcess();
  }

  Future<void> _startProcess() async {
    await widget.startRecording();
    setState(() => isListening = true);
    _controller.repeat(reverse: true);
  }

  void _stopProcess() async {
    _controller.stop();
    await widget.stopRecording();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: h * 0.30,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(vertical: h * 0.01),
      child: Column(
        children: [
          SizedBox(
            width: w * 0.9,
            height: h * 0.08,
            child: isListening
                ? Transform.scale(
              scale: 2.5,
              child: Lottie.asset(
                'assets/audio_wave.json',
                repeat: true,
                animate: true,
              ),
            )
                : const SizedBox.shrink(),
          ),

          SizedBox(height: h * 0.03),

          Container(
            height: h * 0.075,
            width: w * 0.18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isListening ? null : Border.all(color: Colors.grey),
            ),
            child: IconButton(
              icon: Icon(
                isListening
                    ? CupertinoIcons.pause_circle_fill
                    : CupertinoIcons.mic_circle_fill,
                size: 48,
                color: const Color(0xFF1C5F98),
              ),
              onPressed: _stopProcess,
            ),
          ),

          SizedBox(height: h * 0.03),

          Text(
            isListening ? "Recording..." : "Speak your task",
            style: GoogleFonts.roboto(fontSize: 16),
          ),
        ],
      ),
    );
  }
}


