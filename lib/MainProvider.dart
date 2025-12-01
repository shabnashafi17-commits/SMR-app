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

  Reminder({
    required this.id,
    this.taskText,
    this.taskVoice,
    required this.taskType,
    required this.createdAt,
    required this.createdBy,
    required this.createdById,
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
      createdAt = DateTime.now(); // fallback
    }

    return Reminder(
      id: map['id'],
      taskText: map['taskText'],
      taskVoice: map['taskVoice'],
      taskType: map['taskType'],
      createdAt: createdAt,
      createdBy: map['createdBy'],
      createdById: map['createdById'],
    );
  }
}

class MainProvider extends ChangeNotifier {
  List<Reminder> reminders = [];

  MainProvider() {
    fetchReminders();
  }

  final CollectionReference ref =
  FirebaseFirestore.instance.collection("Tasks");

  Future<void> fetchReminders() async {
    final snap = await ref.orderBy("createdAt", descending: true).get();

    reminders = snap.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      data["id"] = e.id; // 🔥 IMPORTANT
      return Reminder.fromMap(data);
    }).toList();

    notifyListeners();
    print("Snap docs: ${snap.docs.map((e) => e.data())}");
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
      contactList.add(
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
