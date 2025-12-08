//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smr_app/user_class.dart';
// import 'MainProvider.dart';
// class SubtaskListContainer extends StatefulWidget {
//   @override
//   _SubtaskListContainerState createState() => _SubtaskListContainerState();
// }
//
// class _SubtaskListContainerState extends State<SubtaskListContainer> {
//   TextEditingController subtaskController = TextEditingController();
//
//   List<String> subtasks = [];
//   bool isTyping = false; // controls textfield visibility
//
//   void onAddButtonPressed() {
//     if (!isTyping) {
//       // FIRST CLICK → SHOW TEXT FIELD
//       setState(() {
//         isTyping = true;
//       });
//     } else {
//       // SECOND CLICK → SAVE SUBTASK
//       String text = subtaskController.text.trim();
//       if (text.isEmpty) return;
//
//       setState(() {
//         subtasks.add(text); // save
//         subtaskController.clear();
//         isTyping = false;   // hide textfield
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Subtask",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//
//           SizedBox(height: 10),
//
//           // SHOW TEXTFIELD ONLY WHEN isTyping = true
//           if (isTyping)
//             Row(
//               children: [
//                 // TEXT FIELD
//                 Expanded(
//                   child: Container(
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 2,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: TextFormField(
//                         controller: subtaskController,
//                         decoration: InputDecoration(
//                           hintText: "Enter Subtask...",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(width: 10),
//
//                 // SAVE BUTTON BESIDE TEXTFIELD
//
//               ],
//             ),
//
//
//           SizedBox(height: 10),
//
//           // SHOW SAVED SUBTASKS
//           Expanded(
//             child: ListView.builder(
//               itemCount: subtasks.length,
//               itemBuilder: (_, i) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6),
//                 child: Container(
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 2,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             subtasks[i],
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//
//                         // Optional delete icon
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//
//           // SINGLE ADD BUTTON
//           Center(child: SizedBox(
//             height: 40,   // ↓ decrease height
//             width: 80,   // ↓ decrease width (optional)
//             child: FloatingActionButton.extended(
//               onPressed: onAddButtonPressed,
//               backgroundColor: Colors.white,
//               foregroundColor: Color(0xff0376FA),
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 side: BorderSide(color: Color(0xff0376FA), width: 1),
//               ),
//               icon: Icon(CupertinoIcons.add_circled),
//               label: Text(isTyping ? "Save" : "Add"),
//             ),
//           ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
// class Reminder {
//   String id;
//   String? taskText;
//   String? taskVoice;
//   String taskType;
//   DateTime createdAt;
//   String createdBy;
//   String createdById;
//
//   Reminder({
//     required this.id,
//     this.taskText,
//     this.taskVoice,
//     required this.taskType,
//     required this.createdAt,
//     required this.createdBy,
//     required this.createdById,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'taskText': taskText,
//       'taskVoice': taskVoice,
//       'taskType': taskType,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'createdBy': createdBy,
//       'createdById': createdById,
//     };
//   }
//
//   static Reminder fromMap(Map<String, dynamic> map) {
//     final createdAtData = map['createdAt'];
//     DateTime createdAt;
//
//     if (createdAtData is Timestamp) {
//       createdAt = createdAtData.toDate();
//     } else if (createdAtData is String) {
//       createdAt = DateTime.parse(createdAtData);
//     } else {
//       createdAt = DateTime.now(); // fallback
//     }
//
//     return Reminder(
//       id: map['id'],
//       taskText: map['taskText'],
//       taskVoice: map['taskVoice'],
//       taskType: map['taskType'],
//       createdAt: createdAt,
//       createdBy: map['createdBy'],
//       createdById: map['createdById'],
//     );
//   }
// }
// class MainProvider extends ChangeNotifier {
//   List<Reminder> reminders = [];
//
//   MainProvider() {
//     fetchReminders();
//   }
//
//   final CollectionReference ref =
//   FirebaseFirestore.instance.collection("Tasks");
//
//   Future<void> fetchReminders() async {
//     final snap = await ref.orderBy("createdAt", descending: true).get();
//
//     reminders = snap.docs.map((e) {
//       final data = e.data() as Map<String, dynamic>;
//       data["id"] = e.id; // 🔥 IMPORTANT
//       return Reminder.fromMap(data);
//     }).toList();
//
//     notifyListeners();
//     print("Snap docs: ${snap.docs.map((e) => e.data())}");
//   }
//   Future<void> addTextReminder(String text) async {
//     final id = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final newReminder = Reminder(
//       id: id,
//       taskText: text,
//       taskVoice: null,
//       taskType: "text",
//       createdAt: DateTime.now(),
//       createdBy: "Admin",
//       createdById: "USER_001",
//     );
//
//     await ref.doc(id).set(newReminder.toMap());
//     reminders.insert(0, newReminder);
//     notifyListeners();
//   }
//
//   Future<void> addVoiceReminder(String audioPath) async {
//     final id = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final newReminder = Reminder(
//       id: id,
//       taskText: null,
//       taskVoice: audioPath,
//       taskType: "voice",
//       createdAt: DateTime.now(),
//       createdBy: "Admin",
//       createdById: "USER_001",
//     );
//
//     await ref.doc(id).set(newReminder.toMap());
//     reminders.insert(0, newReminder);
//     notifyListeners();
//   }
//   List<String> subtasks = [];
//
//   void addSubtask(String task) {
//     if (task.trim().isEmpty) return;
//     subtasks.add(task.trim());
//     notifyListeners();
//   }
//
//   // Nihal
//
//   TextEditingController usernameControler = TextEditingController();
//   TextEditingController contactnumberControler = TextEditingController();
//   Future<bool> addcontact() async {
//     try {
//       // Save to Firebase
//       var docRef = await FirebaseFirestore.instance.collection("contacts").add({
//         "name": usernameControler.text.trim(),
//         "number": contactnumberControler.text.trim(),
//       });
//
//       // Add to local list instantly (UI updates immediately)
//       contactList.insert(
//         0, // index 0 → first element
//         Contact(
//           id: docRef.id,
//           username: usernameControler.text.trim(),
//           userContactNumber: contactnumberControler.text.trim(),
//         ),
//       );
//
//
//       notifyListeners();  // 🔥 refresh ListView immediately
//
//       // Clear controllers
//       usernameControler.clear();
//       contactnumberControler.clear();
//
//       return true; // success
//     } catch (e) {
//       print("Error adding contact: $e");
//       return false; // failed
//     }
//   }  //fetch Function for
//   int tempCheckedList=-1;
//   void chnageAddContact(int index){
//     if (index==tempCheckedList){
//       tempCheckedList=-1;
//     }
//     else {
//       tempCheckedList = index;
//     }
//     notifyListeners();
//   }
//   List<Contact> contactList = [];
//
//   Future<void> fetchContacts() async {
//     try {
//       contactList.clear();
//
//       var snapshot = await FirebaseFirestore.instance.collection("contacts").get();
//
//       for (var doc in snapshot.docs) {
//         contactList.add(
//           Contact(
//             id: doc.id,
//             username: doc['name'] ?? '',
//             userContactNumber: doc['number'] ?? '',
//           ),
//         );
//       }
//       contactList=contactList.reversed.toList();
//       print(contactList.length.toString()+"jghjgh");
//
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching contacts: $e");
//     }
//   }
//
//
//
// // ElevatedButton(
// // onPressed: () {
// // final selected = provider.tempCheckedList == -1
// // ? null
// //     : provider.contactList[provider.tempCheckedList];
// //
// // showDialog(
// // context: context,
// // builder: (context) {
// // return AlertDialog(
// // backgroundColor: Colors.white,
// // content: Text(
// // selected == null
// // ? "No contact selected!"
// //     : "Are you sure you want to assign this task to ${selected.username}?",
// // style: const TextStyle(
// // fontWeight: FontWeight.bold,
// // ),
// // ),
// //
// // actions: [
// // TextButton(
// // onPressed: () => Navigator.pop(context),
// // style: TextButton.styleFrom(
// // backgroundColor: Colors.white, // button background
// // foregroundColor: Colors.black, // text color
// // elevation: 4,                  // shadow
// // shadowColor: Colors.black54,   // shadow color
// // padding: const EdgeInsets.symmetric(horizontal: 16,),
// // shape: RoundedRectangleBorder(
// // borderRadius: BorderRadius.circular(30),
// // ),
// // ),
// // child: const Text(
// // "Cancel",
// // style: TextStyle(
// // fontSize: 12,
// // fontWeight: FontWeight.w600,
// // ),
// // ),
// // ),
// // SizedBox(width: 20,),
// //
// // TextButton(
// // onPressed: () async {
// // final selected = provider.tempCheckedList == -1
// // ? null
// //     : provider.contactList[provider.tempCheckedList];
// //
// // if (selected == null) return;
// //
// // // ⚡ CASE 1: Task already assigned → show replace dialog
// // if (reminder.taskAssignedToId != null &&
// // reminder.taskAssignedToId!.isNotEmpty){
// //
// //
// // showDialog(
// // context: context,
// // builder: (context) {
// // return AlertDialog(
// // backgroundColor: Colors.white,
// // title: const Text("Contact Already Assigned",style: const TextStyle(
// // fontWeight: FontWeight.bold,
// // ),),
// // content: Text(
// // "This task is already assigned to ${reminder.taskAssignedToName ?? ''}"
// // "Do you want to replace this contact?",
// // style: const TextStyle(
// // fontWeight: FontWeight.bold,
// // ),
// // ),
// // actions: [
// // TextButton(
// // onPressed: () => Navigator.pop(context),
// // style: TextButton.styleFrom(
// // backgroundColor: Colors.white, // button background
// // foregroundColor: Colors.black, // text color
// // elevation: 4,                  // shadow
// // shadowColor: Colors.black54,   // shadow color
// // padding: const EdgeInsets.symmetric(horizontal: 16, ),
// // shape: RoundedRectangleBorder(
// // borderRadius: BorderRadius.circular(30),
// // ),
// // ),
// // child: const Text(
// // "No",
// // style: TextStyle(
// // fontSize: 12,
// // fontWeight: FontWeight.w600,
// // ),
// // ),
// // ),
// // SizedBox(width: 20,),
// //
// // TextButton(
// // onPressed: () async {
// // Navigator.pop(context); // close replace dialog
// //
// // await provider.replaceAssignedContact(reminder, selected);
// //
// // ScaffoldMessenger.of(context).showSnackBar(
// // SnackBar(
// // backgroundColor: Colors.blue,
// // content: const Text(
// // "Existing contact replaced successfully!",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 20,
// // fontWeight: FontWeight.w500,
// // ),
// // ),
// // duration: Duration(seconds: 2),
// // ),
// // );
// //
// // provider.tempCheckedList = -1;
// // provider.notifyListeners();
// //
// // Navigator.of(context).pop();
// // Navigator.of(context).pop();
// // },
// //
// // style: TextButton.styleFrom(
// // backgroundColor:Color(0xff0376FA),   // 🔵 blue background
// // foregroundColor: Colors.white,  // ⚪ white text
// // padding: const EdgeInsets.symmetric(horizontal: 16,),
// // shape: RoundedRectangleBorder(
// // borderRadius: BorderRadius.circular(30),
// // ),
// // ),
// //
// // child: const Text(
// // "Replace",
// // style: TextStyle(
// // fontSize: 12,
// // fontWeight: FontWeight.w600,
// // ),
// // ),
// // ),
// //
// // ],
// // );
// // },
// // );
// //
// // return; // STOP normal assign flow
// // }
// //
// // // ⚡ CASE 2: No assigned contact → normal assign
// // bool ok = await provider.assignTask(reminder);
// //
// // if (!ok) {
// // return;
// // } else {
// // ScaffoldMessenger.of(context).showSnackBar(
// // SnackBar(
// // backgroundColor: Colors.blue,
// // content: const Text(
// // "Task assigned successfully!",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 15,
// // fontWeight: FontWeight.w500,
// // ),
// // ),
// // duration: Duration(seconds: 2),
// // ),
// // );
// // }
// //
// // provider.tempCheckedList = -1;
// // provider.notifyListeners();
// //
// // Navigator.pop(context); // close main dialog
// // Navigator.of(context).pop(); // go back
// // },
// // style: TextButton.styleFrom(
// // backgroundColor: Color(0xff0376FA),   // 🔵 blue background
// // foregroundColor: Colors.white,  // ⚪ white text
// // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // shape: RoundedRectangleBorder(
// // borderRadius: BorderRadius.circular(30),
// // ),
// // ),
// //
// // child: const Text(
// // "Assign",
// // style: TextStyle(
// // fontSize: 12,
// // fontWeight: FontWeight.w600,
// // ),
// // ),
// // ),
// // ],
// // );
// // },
// // );
// // },
// // style: ElevatedButton.styleFrom(
// // backgroundColor: Color(0xff0376FA),
// // shape: RoundedRectangleBorder(
// // borderRadius: BorderRadius.circular(18),
// // ),
// // elevation: 2,
// // padding: EdgeInsets.zero,
// // ),
// // child: const Center(
// // child: Text(
// // "Add",
// // style: TextStyle(
// // color: Colors.white,
// // fontWeight: FontWeight.bold,
// // ),
// // ),
// // ),
// // ),
// // // import 'package:flutter/material.dart';
// // //
// // // class HomeScreen extends StatelessWidget {
// // //   const HomeScreen({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     var width = MediaQuery.of(context).size.width;
// // //     var height = MediaQuery.of(context).size.height;
// // //
// // //     List<String> items = [
// // //       "Task 1",
// // //       "Task 2",
// // //       "Task 3",
// // //       "Task 4",
// // //       "Task 5",
// // //       "Task 6",
// // //       "Task 7",
// // //       "Task 8",
// // //       "Task 9",
// // //       "Task 10",
// // //     ];
// // //     List<Map<String, dynamic>> Contactlist = [
// // //       {"name": "Nihal", "number": 6534546},
// // //       {"name": "Ameen", "number": 9876543},
// // //       {"name": "Nihal", "number": 6534546},
// // //       {"name": "Ameen", "number": 9876543},
// // //       {"name": "Nihal", "number": 6534546},
// // //       {"name": "Ameen", "number": 9876543},
// // //     ];
// // //
// // //
// // //
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xffF2F2F2),
// // //       // appBar: AppBar(
// // //       //   backgroundColor: const Color(0xffF2F2F2),
// // //       //   title: const Text(''),
// // //       // ),
// // //       body: Column(
// // //         children: [
// // //           SizedBox(height: height / 13),
// // //           // 🔹 Top Section (Fixed)
// // //           Padding(
// // //             padding: EdgeInsets.only(left: width / 30),
// // //             child: Row(
// // //               children: [
// // //                 const CircleAvatar(
// // //                   backgroundColor: Colors.white,
// // //                   child: Icon(Icons.person),
// // //                 ),
// // //                 SizedBox(width: width / 40),
// // //                 const Text(
// // //                   "Hi, Nihal",
// // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: height / 22),
// // //
// // //           // 🔹 Cards Section (Fixed)
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: width / 24),
// // //             child: Row(
// // //               children: [
// // //                 _buildStatCard(
// // //                   width,
// // //                   height,
// // //                   color: const Color(0xFFFF894D),
// // //                   count: items.length,
// // //                   label: 'Today',
// // //                 ),
// // //                 SizedBox(width: width / 25),
// // //                 _buildStatCard(
// // //                   width,
// // //                   height,
// // //                   color: const Color(0xFF4AC4DF),
// // //                   count: items.length,
// // //                   label: 'Total',
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: height / 28),
// // //
// // //           // 🔹 Tasks Header (Fixed)
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: width / 19),
// // //             child: Row(
// // //               children: [
// // //                 const Text(
// // //                   "Tasks",
// // //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
// // //                 ),
// // //                 const Spacer(),
// // //                 Container(
// // //                   height: width / 10,
// // //                   width: width / 3,
// // //                   decoration: BoxDecoration(
// // //                     borderRadius: BorderRadius.circular(30),
// // //                     color: Colors.black12,
// // //                   ),
// // //                   child: const Center(
// // //                     child: Text(
// // //                       "History",
// // //                       style: TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.black,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: height / 25),
// // //
// // //           // 🔹 Scrollable List Section
// // //           Expanded(
// // //             child: ListView.builder(
// // //               padding: EdgeInsets.symmetric(horizontal: width / 19),
// // //               itemCount: items.length,
// // //               itemBuilder: (context, index) {
// // //                 return Container(
// // //                   margin: const EdgeInsets.only(bottom: 12),
// // //                   padding: const EdgeInsets.all(16),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.white,
// // //                     borderRadius: BorderRadius.circular(16),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       Container(
// // //                         width: width / 10,
// // //                         height: height / 20,
// // //                         decoration: BoxDecoration(
// // //                           color: Color(0xFFFFE7DD),
// // //                           borderRadius: BorderRadius.circular(12),
// // //                         ),
// // //                         child: Icon(
// // //                           Icons.mic_none_outlined,
// // //                           color: Color(0xFFFF894D),
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: width / 30),
// // //                       Expanded(
// // //                         child: Text(
// // //                           items[index],
// // //                           style: const TextStyle(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.w500,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       InkWell(
// // //                         onTap: () {
// // //                           showModalBottomSheet(
// // //                             context: context,
// // //                             builder: (BuildContext context) {
// // //                               // Get the total screen height and define your half-screen height
// // //                               final double halfScreenHeight =
// // //                                   MediaQuery.of(context).size.height / 2;
// // //
// // //                               return Container(
// // //                                 padding: EdgeInsets.only(
// // //                                   bottom: MediaQuery.of(
// // //                                     context,
// // //                                   ).viewInsets.bottom,
// // //                                 ),
// // //                                 child: Column(
// // //                                   mainAxisSize: MainAxisSize.min,
// // //                                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                                   children: <Widget>[
// // //                                     Padding(
// // //                                       padding: EdgeInsets.only(
// // //                                         top: height / 22,
// // //                                         left: width / 10,
// // //                                         bottom: height / 35,
// // //                                       ),
// // //                                       child: Row(
// // //                                         children: [
// // //                                           Text(
// // //                                             "Contact List",
// // //                                             style: TextStyle(
// // //                                               fontSize: 25,
// // //                                               fontWeight: FontWeight.bold,
// // //                                             ),
// // //                                           ),
// // //                                           Spacer(),
// // //                                           Padding(
// // //                                             padding:  EdgeInsets.only(right: 10),
// // //                                             child: Container(
// // //                                               height: height/25,
// // //                                               width: width/6,
// // //                                              decoration: BoxDecoration(
// // //                                                  color: Colors.blue,
// // //                                                borderRadius: BorderRadius.circular(12)
// // //                                              ),
// // //                                               child: Center(
// // //                                                 child: Text("Add",style: TextStyle(
// // //                                                   color: Colors.white,
// // //                                                   fontWeight: FontWeight.bold
// // //                                                 ),),
// // //                                               ),
// // //                                             ),
// // //                                           )
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                     // --- SCROLLABLE LIST CONTENT ---
// // //                                     SizedBox(
// // //                                       height: halfScreenHeight - 60,
// // //                                       // Subtract an estimated height for the heading/padding (~60)
// // //                                       child: ListView.builder(
// // //                                         itemCount: Contactlist.length,
// // //                                         itemBuilder: (context, index) {
// // //                                           final item = Contactlist[index];
// // //                                           return Container(
// // //                                             decoration: BoxDecoration(
// // //                                               border: Border.all(color: Colors.black12),
// // //                                               borderRadius: BorderRadius.circular(12)
// // //
// // //                                             ),
// // //                                             margin: const EdgeInsets.all(8),
// // //                                             child: Padding(
// // //                                               padding: const EdgeInsets.all(12.0),
// // //                                               child: Row(
// // //                                                 children: [
// // //                                                   Icon(Icons.person_add_alt_outlined),
// // //                                                   SizedBox(width: 16),
// // //                                                   Column(
// // //                                                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                                                     children: [
// // //                                                       Text(
// // //                                                         item["name"],
// // //                                                         style: const TextStyle(
// // //                                                           fontWeight: FontWeight.bold,
// // //                                                           fontSize: 16,
// // //                                                         ),
// // //                                                       ),
// // //                                                       const SizedBox(height: 4),
// // //                                                       Text("Phone: ${item["number"]}"),
// // //                                                     ],
// // //                                                   ),
// // //                                                   Spacer(),
// // //                                                   Icon(Icons.check_box_outline_blank)
// // //                                                 ],
// // //                                               ),
// // //                                             ),
// // //                                           );
// // //                                         },
// // //                                       )
// // //
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               );
// // //                             },
// // //                           );
// // //                         },
// // //                         child: Container(
// // //                           width: width / 10,
// // //                           height: height / 20,
// // //                           decoration: BoxDecoration(
// // //                             borderRadius: BorderRadius.circular(20),
// // //                             color: Colors.blue,
// // //                           ),
// // //                           child: const Icon(
// // //                             // Added 'const' since the icon doesn't change
// // //                             Icons.group_add_outlined,
// // //                             color: Colors.white,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // Helper for cards
// // //   Widget _buildStatCard(
// // //     double width,
// // //     double height, {
// // //     required Color color,
// // //     required int count,
// // //     required String label,
// // //   }) {
// // //     return Container(
// // //       width: width / 2.3,
// // //       height: height / 7,
// // //       padding: const EdgeInsets.all(12.0),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(18),
// // //       ),
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Container(
// // //                 width: width / 9,
// // //                 height: height / 20,
// // //                 decoration: BoxDecoration(
// // //                   color: color,
// // //                   borderRadius: BorderRadius.circular(10.0),
// // //                 ),
// // //                 child: const Icon(
// // //                   Icons.calendar_today_outlined,
// // //                   color: Colors.white,
// // //                   size: 22,
// // //                 ),
// // //               ),
// // //               const Spacer(),
// // //               Text(
// // //                 count.toString(),
// // //                 style: const TextStyle(
// // //                   fontSize: 32,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.black87,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           Text(
// // //             label,
// // //             style: TextStyle(
// // //               fontSize: 14,
// // //               fontWeight: FontWeight.w600,
// // //               color: color,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_sound/flutter_sound.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // class ReminderPage1 extends StatefulWidget {
// //   const ReminderPage1({super.key});
// //
// //   @override
// //   State<ReminderPage1> createState() => _ReminderPage1State();
// // }
// //
// // class _ReminderPage1State extends State<ReminderPage1> {
// //   final TextEditingController _controller = TextEditingController();
// //   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// //   final FlutterSoundPlayer _player = FlutterSoundPlayer();
// //
// //   bool _isRecording = false;
// //   bool _isPlaying = false;
// //   String? _filePath;
// //
// //   // Unified list for both text and voice reminders
// //   List<Map<String, String?>> reminders = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initAudio();
// //   }
// //
// //   Future<void> _initAudio() async {
// //     await Permission.microphone.request();
// //     await Permission.storage.request();
// //
// //     await _recorder.openRecorder();
// //     await _player.openPlayer();
// //     await _player.setSubscriptionDuration(const Duration(milliseconds: 100));
// //   }
// //
// //   Future<void> _startRecording() async {
// //     final dir = await getApplicationDocumentsDirectory();
// //     _filePath =
// //     '${dir.path}/reminder_record_${DateTime.now().millisecondsSinceEpoch}.aac';
// //
// //     await _recorder.startRecorder(
// //       toFile: _filePath,
// //       codec: Codec.aacADTS,
// //     );
// //
// //     setState(() => _isRecording = true);
// //   }
// //
// //   Future<void> _stopRecording() async {
// //     await _recorder.stopRecorder();
// //     setState(() => _isRecording = false);
// //
// //     if (_filePath != null) {
// //       reminders.add({'text': null, 'audio': _filePath});
// //     }
// //
// //     setState(() {});
// //   }
// //
// //   Future<void> _playAudio(String filePath) async {
// //     if (!File(filePath).existsSync()) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Audio file not found!')),
// //       );
// //       return;
// //     }
// //
// //     if (_isPlaying) {
// //       await _player.stopPlayer();
// //       setState(() => _isPlaying = false);
// //     } else {
// //       await _player.startPlayer(
// //         fromURI: filePath,
// //         codec: Codec.aacADTS,
// //         whenFinished: () {
// //           setState(() => _isPlaying = false);
// //         },
// //       );
// //       setState(() => _isPlaying = true);
// //     }
// //   }
// //
// //   void _saveReminder() {
// //     final reminderText = _controller.text.trim();
// //
// //     if (reminderText.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please type a message')),
// //       );
// //       return;
// //     }
// //
// //     reminders.add({'text': reminderText, 'audio': null});
// //     _controller.clear();
// //     setState(() {});
// //   }
// //
// //   @override
// //   void dispose() {
// //     _recorder.closeRecorder();
// //     _player.closePlayer();
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   Widget _buildReminderItem(Map<String, String?> reminder, int index) {
// //     final isAudio = reminder['audio'] != null;
// //
// //     return Align(
// //       alignment: Alignment.centerRight,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: isAudio ? Colors.lightBlue[50] : Colors.blue[100],
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (isAudio)
// //               IconButton(
// //                 icon: Icon(
// //                   _isPlaying ? Icons.stop : Icons.play_arrow,
// //                   color: Colors.blueAccent,
// //                 ),
// //                 onPressed: () => _playAudio(reminder['audio']!),
// //               ),
// //             if (!isAudio)
// //               Flexible(
// //                 child: Text(
// //                   reminder['text'] ?? '',
// //                   style: const TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //             IconButton(
// //               icon: const Icon(Icons.delete, color: Colors.red),
// //               onPressed: () {
// //                 reminders.removeAt(index);
// //                 setState(() {});
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Reminders (Text + Voice)"),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: reminders.isEmpty
// //                 ? const Center(child: Text("No reminders yet."))
// //                 : ListView.builder(
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               itemCount: reminders.length,
// //               itemBuilder: (context, index) =>
// //                   _buildReminderItem(reminders[index], index),
// //             ),
// //           ),
// //
// //           // Input Row (TextField + Mic)
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                     color: Colors.grey.shade300,
// //                     offset: const Offset(0, -1),
// //                     blurRadius: 4)
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 // Text input
// //                 Expanded(
// //                   child: TextFormField(
// //                     controller: _controller,
// //                     decoration: InputDecoration(
// //                       hintText: "Type a reminder...",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       contentPadding:
// //                       const EdgeInsets.symmetric(horizontal: 16),
// //                       suffixIcon: IconButton(
// //                         icon:
// //                         const Icon(Icons.add, color: Colors.blueAccent),
// //                         onPressed: _saveReminder,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //
// //                 // Mic Button
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     color: _isRecording
// //                         ? Colors.redAccent
// //                         : Colors.blueAccent,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: IconButton(
// //                     icon: Icon(
// //                       _isRecording ? Icons.stop : Icons.mic,
// //                       color: Colors.white,
// //                     ),
// //                     onPressed: () async {
// //                       if (_isRecording) {
// //                         await _stopRecording();
// //                       } else {
// //                         await _startRecording();
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: const HomeScreen(),
// //     );
// //   }
// // }
// // //HOME SCREEN
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// //
// //
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
// //   final TextEditingController _controller = TextEditingController();
// //   final FocusNode _focusNode = FocusNode();
// //
// //   bool isEditing = false;
// //   List<bool> isCheckedList = [];
// //
// //   List<Map<String, dynamic>> Contactlist = [
// //     {"name": "Nihal", "number": 6534546},
// //     {"name": "Ameen", "number": 9876543},
// //     {"name": "Nihal", "number": 6534546},
// //     {"name": "Ameen", "number": 9876543},
// //     {"name": "Nihal", "number": 6534546},
// //     {"name": "Ameen", "number": 9876543},
// //   ];
// //
// //
// //   List<String> items = [
// //     "Task 1",
// //     "Task 2",
// //     "Task 3",
// //     "Task 4",
// //     "Task 5",
// //     "Task 6",
// //   ];
// //
// //   List<Map<String, dynamic>> contactList = [
// //     {"name": "Nihal", "number": 6534546},
// //     {"name": "Ameen", "number": 9876543},
// //     {"name": "Salman", "number": 7654321},
// //   ];
// //
// //
// //   // ReminderPage audio/text integration
// //   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// //   final FlutterSoundPlayer _player = FlutterSoundPlayer();
// //
// //
// //   bool _isRecording = false;
// //   bool _isPlaying = false;
// //   String? _filePath;
// //   List<Map<String, String?>> reminders = [];
// //
// //   get bottomNavigationBar => null;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initAudio();
// //   }
// //
// //   Future<void> _initAudio() async {
// //     await Permission.microphone.request();
// //     await Permission.storage.request();
// //
// //     await _recorder.openRecorder();
// //     await _player.openPlayer();
// //     await _player.setSubscriptionDuration(const Duration(milliseconds: 100));
// //   }
// //
// //   Future<void> _startRecording() async {
// //     final dir = await getApplicationDocumentsDirectory();
// //     _filePath =
// //     '${dir.path}/reminder_record_${DateTime.now().millisecondsSinceEpoch}.aac';
// //     await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
// //     setState(() => _isRecording = true);
// //   }
// //
// //   Future<void> _stopRecording() async {
// //     await _recorder.stopRecorder();
// //     setState(() => _isRecording = false);
// //     if (_filePath != null) {
// //       reminders.add({'text': null, 'audio': _filePath});
// //       setState(() {});
// //     }
// //   }
// //
// //   Future<void> _playAudio(String filePath) async {
// //     if (!File(filePath).existsSync()) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(const SnackBar(content: Text('Audio file not found!')));
// //       return;
// //     }
// //     if (_isPlaying) {
// //       await _player.stopPlayer();
// //       setState(() => _isPlaying = false);
// //     } else {
// //       await _player.startPlayer(
// //           fromURI: filePath,
// //           codec: Codec.aacADTS,
// //           whenFinished: () {
// //             setState(() => _isPlaying = false);
// //           });
// //       setState(() => _isPlaying = true);
// //     }
// //   }
// //
// //   void _saveReminder() {
// //     final text = _controller.text.trim();
// //     if (text.isEmpty) return;
// //     reminders.add({'text': text, 'audio': null});
// //     _controller.clear();
// //     setState(() {});
// //   }
// //
// //   Widget _buildReminderItem(Map<String, String?> reminder, int index) {
// //     final isAudio = reminder['audio'] != null;
// //     return Align(
// //       alignment: Alignment.centerRight,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: isAudio ? Colors.lightBlue[50] : Colors.blue[100],
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (isAudio)
// //               IconButton(
// //                 icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow,
// //                     color: Colors.blueAccent),
// //                 onPressed: () => _playAudio(reminder['audio']!),
// //               ),
// //             if (!isAudio)
// //               Flexible(
// //                   child: Text(
// //                     reminder['text'] ?? '',
// //                     style: const TextStyle(fontSize: 16),
// //                   )),
// //             IconButton(
// //               icon: const Icon(Icons.delete, color: Colors.red),
// //               onPressed: () {
// //                 reminders.removeAt(index);
// //                 setState(() {});
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _recorder.closeRecorder();
// //     _player.closePlayer();
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<int> voiceNumbers = [];
// //     int count = 0;
// //
// //     for (var r in reminders) {
// //       if (r['audio'] != null) {
// //         count++;
// //         voiceNumbers.add(count);
// //       } else {
// //         voiceNumbers.add(0);
// //       }
// //     }
// //
// //     var width = MediaQuery.of(context).size.width;
// //     var height = MediaQuery.of(context).size.height;
// //
// //
// //     return Scaffold(
// //       resizeToAvoidBottomInset: true,
// //       backgroundColor: const Color(0xffF2F2F2),
// //       body:  Column(
// //         children: [
// //           SizedBox(height: height / 13),
// //           // Greeting
// //           Padding(
// //             padding: EdgeInsets.only(left: width / 30),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   backgroundColor: Colors.white,
// //                   radius: 20, // optional
// //                   child: Image.asset(
// //                     "assets/Frame6.png",
// //                     width: 20,
// //                     height: 20,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //                 SizedBox(width: width / 40),
// //                 const Text("Hi, Nihal",
// //                     style: TextStyle(fontWeight: FontWeight.bold)),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: height / 22),
// //           // Stats Cards
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: width / 24),
// //             child: Row(
// //               children: [
// //                 _buildStatCard(
// //                   width,
// //                   height,
// //                   count: reminders.length,
// //                   label: 'Today',
// //                   assetPath: "assets/Frame3.png",
// //                   color: Color(0xffFF6B2C),
// //
// //
// //                 ),
// //
// //                 SizedBox(width: width / 25),
// //                 _buildStatCard(
// //                     width,
// //                     height,
// //                     count: 5,
// //                     label: 'Total',
// //                     assetPath: "assets/Frame5.png",
// //                     color: Color(0xff00B9D6)
// //
// //                 ),
// //
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: height / 28),
// //           // Tasks Header
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: width / 19),
// //             child: Row(
// //               children: [
// //                 const Text("Tasks",
// //                     style:
// //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
// //                 const Spacer(),
// //                 GestureDetector(
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => HistoryScreen()),  // 👉 your page
// //                     );
// //                   },
// //                   child: Container(
// //                     height: width / 8,
// //                     width: width / 3.5,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(30),
// //                       color: Color(0xffEDEDED),
// //                     ),
// //                     child: const Center(
// //                       child: Text(
// //                         "History",
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.w500,
// //                           color: Colors.black,
// //                           fontSize: 18,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: height / 25),
// //
// //           Expanded(
// //             child: ListView.builder(
// //               padding: EdgeInsets.symmetric(horizontal: width / 19),
// //               itemCount: reminders.length,
// //               itemBuilder: (context, index) {
// //                 final reminder = reminders[index];
// //
// //                 // Get pre-calculated correct voice count
// //                 int voiceCount = voiceNumbers[index];
// //
// //                 return InkWell(
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => Taskdetailspage()),
// //                     );
// //                   },
// //                   child: Container(
// //                     margin: const EdgeInsets.only(bottom: 12),
// //                     padding: const EdgeInsets.all(16),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         // icon
// //                         Container(
// //                           width: width / 10,
// //                           height: height / 20,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFFFE7DD),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Icon(
// //                             reminder['audio'] != null
// //                                 ? Icons.mic_none_outlined
// //                                 : Icons.checklist,
// //                             size: 24,
// //                             color: const Color(0xFFFE6B2C),
// //                           ),
// //                         ),
// //
// //                         SizedBox(width: width / 30),
// //
// //                         // TEXT COLUMN
// //                         Expanded(
// //                           child: reminder['audio'] != null
// //                               ? Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 "Voice - $voiceCount",
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: Colors.grey,
// //                                 ),
// //                               ),
// //                             ],
// //                           )
// //                               : Text(
// //                             reminder['text'] ?? "",
// //                             style: TextStyle(
//   fontSize: 16,
// //                               fontWeight: FontWeight.w700,
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ),
// //
// //
// //                         // Play button for voice reminders
// //                         if (reminder['audio'] != null)
// //                           IconButton(
// //                             icon: Icon(
// //                               _isPlaying ? Icons.stop : Icons.play_arrow,
// //                               color: Colors.blueAccent,
// //                             ),
// //                             onPressed: () => _playAudio(reminder['audio']!),
// //                           ),
// //
// //                         // Group add button
// //                         InkWell(
// //                           onTap: () {
// //                             if (isCheckedList.length != Contactlist.length) {
// //                               isCheckedList =
// //                                   List.generate(Contactlist.length, (_) => false);
// //                             }
// //                             showModalBottomSheet(
// //                               context: context,
// //                               backgroundColor: Color(0xffF2F2F2),
// //                               builder: (BuildContext context) {
// //                                 final double halfScreenHeight =
// //                                     MediaQuery.of(context).size.height / 2;
// //                                 return Container(
// //                                   padding: EdgeInsets.only(
// //                                     bottom: MediaQuery.of(context).viewInsets.bottom,
// //                                   ),
// //                                   child: Column(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                     children: <Widget>[
// //                                       Padding(
// //                                         padding: EdgeInsets.only(
// //                                           top: height / 22,
// //                                           left: width / 30,
// //                                           bottom: height / 35,
// //                                         ),
// //                                         child: Row(
// //                                           children: [
// //                                             Text(
// //                                               "Contact List",
// //                                               style: TextStyle(
// //                                                 fontSize: 25,
// //                                                 fontWeight: FontWeight.bold,
// //                                               ),
// //                                             ),
// //                                             Spacer(),
// //                                             Padding(
// //                                               padding: EdgeInsets.only(right: 10),
// //                                               child: SizedBox(
// //                                                 height: height / 25,
// //                                                 width: width / 6,
// //                                                 child: ElevatedButton(
// //                                                   onPressed: () {
// //                                                     // TODO: Add your action here
// //                                                   },
// //                                                   style: ElevatedButton.styleFrom(
// //                                                     backgroundColor: Colors.blue,     // button color
// //                                                     shape: RoundedRectangleBorder(
// //                                                       borderRadius: BorderRadius.circular(18),   // same radius
// //                                                     ),
// //                                                     elevation: 2,
// //                                                     padding: EdgeInsets.zero,                   // remove default padding
// //                                                   ),
// //                                                   child: Center(
// //                                                     child: Text(
// //                                                       "Add",
// //                                                       style: TextStyle(
// //                                                         color: Colors.white,
// //                                                         fontWeight: FontWeight.bold,
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //
// //                                             )
// //
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       SizedBox(
// //                                         height: halfScreenHeight - 60,
// //                                         child: ListView.builder(
// //                                           itemCount: Contactlist.length,
// //                                           itemBuilder: (context, index) {
// //                                             final item = Contactlist[index];
// //                                             return Container(
// //                                               decoration: BoxDecoration(
// //                                                 borderRadius: BorderRadius.circular(12),
// //                                                 color: Colors.white,
// //                                               ),
// //                                               margin: const EdgeInsets.all(8),
// //                                               child: Padding(
// //                                                 padding: const EdgeInsets.all(12.0),
// //                                                 child: Row(
// //                                                   children: [
// //                                                     Icon(Icons.person_outline),
// //                                                     SizedBox(width: 16),
// //                                                     Column(
// //                                                       crossAxisAlignment:
// //                                                       CrossAxisAlignment.start,
// //                                                       children: [
// //                                                         Text(
// //                                                           item["name"],
// //                                                           style: const TextStyle(
// //                                                             fontWeight: FontWeight.bold,
// //                                                             fontSize: 16,
// //                                                           ),
// //                                                         ),
// //                                                         const SizedBox(height: 4),
// //                                                         Text("Phone: ${item["number"]}"),
// //                                                       ],
// //                                                     ),
// //                                                     Spacer(),
// //                                                     StatefulBuilder(
// //                                                       builder: (context, setState) {
// //                                                         return InkWell(
// //                                                           onTap: () {
// //                                                             setState(() {
// //                                                               isCheckedList[index] =
// //                                                               !isCheckedList[index];
// //                                                             });
// //                                                           },
// //                                                           child: Icon(
// //                                                             isCheckedList[index]
// //                                                                 ? Icons.check_box_outlined
// //                                                                 : Icons.check_box_outline_blank,
// //                                                             color: Colors.black,
// //                                                           ),
// //                                                         );
// //                                                       },
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             );
// //                                           },
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 );
// //                               },
// //                             );
// //                           },
// //                           child: Container(
// //                             width: width / 10,
// //                             height: height / 20,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(20),
// //                               color: Colors.blue,
// //                             ),
// //                             child: const Icon(
// //                               Icons.group_add_outlined,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //       // Bottom input bar
// //       bottomNavigationBar: _buildBottomInputBar(height, width),
// //     );
// //   }
// //   Widget _buildBottomInputBar(double height, double width) {
// //     return Padding(
// //       padding: EdgeInsets.only(
// //         bottom: MediaQuery.of(context).viewInsets.bottom, // ⭐ Moves above keyboard
// //       ),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,                     // ⭐ White card background
// //           borderRadius: BorderRadius.circular(12),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black26,               // ⭐ Shadow color you asked for
// //               blurRadius: 15,
// //               spreadRadius: 0,
// //               offset: Offset(0, 6),               // ⭐ Shadow on TOP
// //             ),
// //           ],
// //         ),
// //         height: height * 100 / 932,
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
// //         child: Stack(
// //           children: [
// //
// //             /// ⭐ TEXT FIELD
// //             Positioned.fill(
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: _controller,
// //                       focusNode: _focusNode,
// //                       decoration: InputDecoration(
// //                         hintText: "Enter Your Task",
// //                         hintStyle: TextStyle(
// //                           color: Colors.grey,
// //                           fontSize: 16,
// //                         ),
// //                         contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 16,
// //                           vertical: 0,
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(
// //                             color: Colors.black12,
// //                             width: 1,
// //                           ),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(
// //                             color: Colors.black12,
// //                             width: 1,
// //                           ),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(width: 60),
// //                 ],
// //               ),
// //             ),
// //
// //             /// ⭐ FLOATING BUTTON
// //             Positioned(
// //               right: 0,
// //               bottom: 5,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: _focusNode.hasFocus ? Colors.green : Color(0xff074899),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: IconButton(
// //                   icon: Icon(
// //                     _focusNode.hasFocus ? Icons.add : Icons.mic,
// //                     color: Colors.white,
// //                   ),
// //                   onPressed: () async {
// //                     if (_focusNode.hasFocus) {
// //                       _saveReminder();
// //                       _focusNode.unfocus();
// //                     } else {
// //                       showModalBottomSheet(
// //                         context: context,
// //                         backgroundColor: Colors.transparent,
// //                         isScrollControlled: true,
// //                         builder: (context) => TokenBottomSheet(
// //                           startRecording: _startRecording,
// //                           stopRecording: _stopRecording,
// //                         ),
// //                       );
// //                     }
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //
// //
// //   Widget _buildStatCard(double width, double height,
// //       {  required  color, required int count, required String label, required String assetPath}) {
// //     return Container(
// //       width: width / 2.3,
// //       //height: height / 10,
// //       padding: const EdgeInsets.all(12.0),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(30),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,   // small light shadow
// //             blurRadius: 1,           // smooth edge
// //             offset: Offset(0, 1),    // shadow direction
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 width: width / 9,
// //                 height: height / 18,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(10.0),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(2.0),
// //                   child: Image.asset(
// //                     assetPath,      // 👈 USE ARGUMENT HERE
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //               ),
// //               const Spacer(),
// //               Padding(
// //                 padding: const EdgeInsets.only(right: 10),
// //                 child: Text(
// //                   count.toString(),
// //                   style: const TextStyle(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black87,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),          Text(
// //             label,
// //             style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w800,
// //                 color: color
// //
// //
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }}//
