import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'createdById': createdById,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      taskText: map['taskText'],
      taskVoice: map['taskVoice'],
      taskType: map['taskType'],
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'],
      createdById: map['createdById'],
    );
  }
}

class MainProvider extends ChangeNotifier {
  List<Reminder> reminders = [];

  final CollectionReference ref =
  FirebaseFirestore.instance.collection("Tasks");

  Future<void> fetchReminders() async {
    final snap = await ref.orderBy("createdAt", descending: true).get();

    reminders = snap.docs
        .map((e) => Reminder.fromMap(e.data() as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }
  Future<void> addTextReminder(String text) async {
    final id = ref.doc().id;

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

    // Add new reminder at the top of the local list
    reminders.insert(0, newReminder);
    notifyListeners(); // triggers UI update immediately
  }

  Future<void> addVoiceReminder(String audioPath) async {
    final id = ref.doc().id;

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

    // Add new reminder at the top of the local list
    reminders.insert(0, newReminder);
    notifyListeners(); // triggers UI update immediately
  }

  Future<void> createDummyUser() async {
    final CollectionReference usersRef =
    FirebaseFirestore.instance.collection("USERS");

    final id = usersRef.doc().id; // auto-id

    await usersRef.doc(id).set({
      "id": id,
      "name": "John Doe",
      "email": "john@example.com",
      "age": 25,
      "createdAt": DateTime.now().toIso8601String(),
    });
       notifyListeners();
  }

}
