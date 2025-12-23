import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/MainProvider.dart';
import 'package:smr_app/ADMIN%20SIDE/home_Screen.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  String? otpError;
  String? phoneError;



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
            key: _formKey,
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
                // PHONE NUMBER FIELD
                SizedBox(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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

                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,

                          // 🔥 10-Digit Limit + Numbers Only
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],

                          onChanged: (value) {
                            setState(() {
                              if (value.length != 10) {
                                phoneError = "Enter valid 10-digit number";
                              } else {
                                phoneError = null;
                              }
                            });
                          },

                          decoration: InputDecoration(
                            hintText: "Enter phone number",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                            prefixText: "+91 ",
                            counterText: "",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                        ),
                      ),

                      // 🔥 SHOW PHONE VALIDATION ERROR BELOW FIELD
                      if (phoneError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            phoneError!,
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                    ],
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
                        String phone = phoneController.text.trim();

                        if (phone.length != 10) {
                          setState(() {
                            phoneError = "Enter a valid 10-digit phone number";
                          });
                          return; // Stop here, don't show OTP field
                        }

                        // Phone is valid → show OTP input
                        setState(() {
                          phoneError = null;
                          showOtpField = true;
                        });
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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

                            onChanged: (value) {
                              setState(() {
                                if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
                                  otpError = "Please enter a valid 6-digit OTP";
                                } else {
                                  otpError = null;
                                }

                              });
                            },

                            decoration: InputDecoration(
                              hintText: "6-digit OTP",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
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

                        // 🔥 ERROR TEXT DISPLAY
                        if (otpError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              otpError!,
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),


                  SizedBox(
                    width: 320,
                    height: 50,
                    child: Consumer<MainProvider>(
                      builder: (context,provider,child) {
                        return ElevatedButton(
                          onPressed: () async{
                            if (otpController.text.trim().length != 6) {
                              setState(() {
                                otpError = "Please enter a valid 6-digit OTP";
                              });
                              return; // stop here
                            }
                           await provider.fetchReminders();
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
                        );
                      }
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
