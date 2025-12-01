import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/user_class.dart';

class Reminder {
  String id;
  String? taskText;
  String? taskVoice;
  String taskType;
  DateTime createdAt;
  String createdBy;
  String createdById;
  List<String> subtasks; // ✅ Add this

  Reminder({
    required this.id,
    this.taskText,
    this.taskVoice,
    required this.taskType,
    required this.createdAt,
    required this.createdBy,
    required this.createdById,
    this.subtasks = const [], // default empty
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskText': taskText,
      'taskVoice': taskVoice,
      'taskType': taskType,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'createdById': createdById,
      'subtasks': subtasks, // ✅ Save subtasks in Firebase
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    final createdAtData = map['createdAt'];
    DateTime createdAt;

    if (createdAtData is Timestamp) {
      createdAt = createdAtData.toDate();
    } else if (createdAtData is String) {
      createdAt = DateTime.parse(createdAtData);
    } else {
      createdAt = DateTime.now();
    }

    return Reminder(
      id: map['id'],
      taskText: map['taskText'],
      taskVoice: map['taskVoice'],
      taskType: map['taskType'],
      createdAt: createdAt,
      createdBy: map['createdBy'],
      createdById: map['createdById'],
      subtasks: List<String>.from(map['subtasks'] ?? []), // ✅ load subtasks
    );
  }
}

class MainProvider extends ChangeNotifier {
  List<Reminder> reminders = [];
  final CollectionReference ref = FirebaseFirestore.instance.collection("Tasks");

  MainProvider() {
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    final snap = await ref.orderBy("createdAt", descending: true).get();
    reminders = snap.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      data["id"] = e.id;
      return Reminder.fromMap(data);
    }).toList();
    notifyListeners();
  }

  Future<void> addTextReminder(String text) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newReminder = Reminder(
      id: id,
      taskText: text,
      taskVoice: null,
      taskType: "text",
      createdAt: DateTime.now(),
      createdBy: "Admin",
      createdById: "USER_001",
    );
    await ref.doc(id).set(newReminder.toMap());
    reminders.insert(0, newReminder);
    notifyListeners();
  }

  Future<void> addVoiceReminder(String audioPath) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newReminder = Reminder(
      id: id,
      taskText: null,
      taskVoice: audioPath,
      taskType: "voice",
      createdAt: DateTime.now(),
      createdBy: "Admin",
      createdById: "USER_001",
    );
    await ref.doc(id).set(newReminder.toMap());
    reminders.insert(0, newReminder);
    notifyListeners();
  }

  /// ✅ Add a subtask to a reminder
  Future<void> addSubtaskToReminder(String reminderId, String text) async {
    if (text.trim().isEmpty) return;

    final index = reminders.indexWhere((r) => r.id == reminderId);
    if (index == -1) return;

    reminders[index].subtasks.add(text.trim());
    notifyListeners();

    try {
      await ref.doc(reminderId).update({
        'subtasks': reminders[index].subtasks,
      });
    } catch (e) {
      print("Error updating subtask: $e");
    }
  }




  // Nihal

  TextEditingController usernameControler = TextEditingController();
  TextEditingController contactnumberControler = TextEditingController();
  Future<bool> addcontact() async {
    try {
      // Save to Firebase
      var docRef = await FirebaseFirestore.instance.collection("contacts").add({
        "name": usernameControler.text.trim(),
        "number": contactnumberControler.text.trim(),
      });

      // Add to local list instantly (UI updates immediately)
      contactList.insert(
        0, // index 0 → first element
        Contact(
          id: docRef.id,
          username: usernameControler.text.trim(),
          userContactNumber: contactnumberControler.text.trim(),
        ),
      );


      notifyListeners();  // 🔥 refresh ListView immediately

      // Clear controllers
      usernameControler.clear();
      contactnumberControler.clear();

      return true; // success
    } catch (e) {
      print("Error adding contact: $e");
      return false; // failed
    }
  }  //fetch Function for
  int tempCheckedList=-1;
  void chnageAddContact(int index){
    if (index==tempCheckedList){
      tempCheckedList=-1;
    }
    else {
      tempCheckedList = index;
    }
    notifyListeners();
  }
  List<Contact> contactList = [];

  Future<void> fetchContacts() async {
    try {
      contactList.clear();

      var snapshot = await FirebaseFirestore.instance.collection("contacts").get();

      for (var doc in snapshot.docs) {
        contactList.add(
          Contact(
            id: doc.id,
            username: doc['name'] ?? '',
            userContactNumber: doc['number'] ?? '',
          ),
        );
      }
      contactList=contactList.reversed.toList();
      print(contactList.length.toString()+"jghjgh");

      notifyListeners();
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

}
