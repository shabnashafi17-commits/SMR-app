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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    if (isListening) {
      _controller.stop();
      Navigator.of(context).pop();
    } else {
      setState(() {
        isListening = true;
      });
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.3,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical:screenHeight*1/932),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  Animated bar
          SizedBox(
            width:screenWidth*350/430,
            height:screenHeight*70/932,
            child:isListening
                ? Transform.scale(
              scale: 2.5,
              child: Lottie.asset(
                'assets/audio_wave.json',
                repeat: true,
                animate: true,
                fit: BoxFit.contain,
              ),
            )
                : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          SizedBox(height:screenHeight* 30/932),

          // Mic Icon Button
          Container(
            height:screenHeight* 70/932,
            width:screenWidth* 70/430,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isListening
                  ? null
                  : Border.all(
                color: Colors.grey,
                width: 1,
              ),
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

          SizedBox(height:screenHeight*35/932),

          //  Text label
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
