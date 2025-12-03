import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'MainProvider.dart';
import 'home_Screen.dart';

class ContactAsign extends StatelessWidget {
  ContactAsign({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("nihal pushedddd");

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> Contactlist = [
      {"name": "Nihal", "number": 6534546},
      {"name": "Ameen", "number": 9876543},
      {"name": "Nihal", "number": 6534546},
      {"name": "Ameen", "number": 9876543},
      {"name": "Nihal", "number": 6534546},
      {"name": "Ameen", "number": 9876543},
      {"name": "Ameen", "number": 9876543},

    ];
    // final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(backgroundColor: Color(0xffF2F2F2),
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:(context) => HomeScreen(),));
            },
            child: Icon(Icons.arrow_back_ios)),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key:_formKey ,
            child: Column(
              children: [
                //User name Textfield
                Consumer<MainProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: EdgeInsets.only(left: width / 20, right: width / 20),
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
                          child:TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: provider.usernameControler,
                            decoration: InputDecoration(
                              hintText: "User Name",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                              border: InputBorder.none,
                            ),

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "PLEASE FILL USER NAME";
                              }
                              return null;
                            },
                            inputFormatters: [
                              OnlyLettersFirstCapitalFormatter(),
                            ],
                          )


                      ),
                    );
                  },
                ),
                SizedBox(height: height / 30),
                //User name contact Textfield
                Consumer<MainProvider>(
                    builder: (context,provider,child) {
                      return Padding(
                          padding: EdgeInsets.only(left: width / 20, right: width / 20),
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
                              child:TextFormField(
                                controller: provider.contactnumberControler,
                                decoration: InputDecoration(
                                  hintText: "Contact Number",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "PLEASE FILL CONTACT NUMBER";
                                  }
                                  if (value.length < 10) {
                                    return "NUMBER MUST BE 10 DIGITS";
                                  }
                                  return null;
                                },
                              )


                          )

                      );
                    }
                ),

                SizedBox(height: height / 30),
                Padding(
                  padding: EdgeInsets.only(left: width / 30, right: width / 30),
                  child: Consumer<MainProvider>(
                      builder: (context,provider,child) {
                        return TextButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return; // ❌ Stop if validation fails
                            }
                            bool result = await provider.addcontact();

                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });

                                return AlertDialog(
                                  content: Padding(
                                    padding: EdgeInsets.only(left: width / 8),
                                    child: Text(
                                      result ? "Contact Added Successfully ✅"
                                          : "Failed! ❌ Try Again",
                                      style: TextStyle(
                                        color: result ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          child: Container(
                            height: height / 16,
                            width: width / 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            child:  Text(
              "Contact List",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded (
            // Subtract an estimated height for the heading/padding (~60)
            child: Consumer<MainProvider>(
                builder: (context,provier,child) {
                  return ListView.builder(
                    itemCount: provier.contactList.length,
                    itemBuilder: (context, index) {
                      final contact = provier.contactList[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .person_outline,
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text("Name: ${contact.username}",
                                    style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ("Phone: ${contact.userContactNumber}"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );

  }
}
class OnlyLettersFirstCapitalFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    // Remove any character that is NOT a–z or A–Z
    String filtered = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    if (filtered.isEmpty) {
      return TextEditingValue(text: '');
    }

    // Make first letter uppercase and rest lowercase
    filtered = filtered[0].toUpperCase() +
        (filtered.length > 1 ? filtered.substring(1).toLowerCase() : '');

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}