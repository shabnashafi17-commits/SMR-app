import 'package:flutter/material.dart';
import 'package:smr_app/home_Screen.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool showOtpField = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff074899),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Login using your phone number",
                  style: TextStyle(color: Colors.grey[700]),
                ),

                SizedBox(height: 40),

                // PHONE NUMBER LABEL
                Align(

                  child: Padding(
                    padding: const EdgeInsets.only(right: 195),
                    child: Text(
                      "Phone Number",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // PHONE NUMBER FIELD
                SizedBox(
                  width: 320,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter phone number",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600, // <-- Hint text color
                          fontSize: 16,
                        ),
                        prefixText: "+91 ",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // SEND OTP BUTTON
                if (!showOtpField)
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (phoneController.text.trim().length == 10) {
                          setState(() {
                            showOtpField = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff074899),
                      ),
                      child: Text(
                        "Send OTP",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                // OTP SECTION
                if (showOtpField) ...[
                  SizedBox(height: 20),

                  // OTP LABEL
                  Align(

                    child: Padding(
                      padding: const EdgeInsets.only(right: 227),
                      child: Text(
                        "Enter OTP",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // OTP FIELD (MATCHING PHONE FIELD STYLE)
                  SizedBox(
                    width: 320,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: "6-digit OTP",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600, // <-- Hint text color
                            fontSize: 16,
                          ),
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // VERIFY OTP BUTTON
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff074899),
                      ),
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
