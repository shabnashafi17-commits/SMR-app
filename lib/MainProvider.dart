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
}
