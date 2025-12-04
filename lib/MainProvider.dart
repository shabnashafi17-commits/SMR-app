import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_class.dart'; // your Contact class

class Reminder {
  String id;
  String? taskText;
  String? taskVoice;
  String taskType;
  DateTime createdAt;
  String createdBy;
  String createdById;
  List<String> subtasks;
  DateTime? date;         // selected date
  Duration? time;         // selected time
  String reminderOption;
  String? assignedContactId;   // add this
// e.g. "5 min Before"

  Reminder({
    required this.id,
    this.taskText,
    this.taskVoice,
    required this.taskType,
    required this.createdAt,
    required this.createdBy,
    required this.createdById,
    this.subtasks = const [],
    this.date,
    this.time,
    this.reminderOption = "No Reminder",
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
      'subtasks': subtasks,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'time': time != null ? time!.inSeconds : null,
      'reminderOption': reminderOption,
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

    DateTime? date;
    if (map['date'] != null) {
      date = (map['date'] as Timestamp).toDate();
    }

    Duration? time;
    if (map['time'] != null) {
      time = Duration(seconds: map['time']);
    }

    return Reminder(
      id: map['id'],
      taskText: map['taskText'],
      taskVoice: map['taskVoice'],
      taskType: map['taskType'],
      createdAt: createdAt,
      createdBy: map['createdBy'],
      createdById: map['createdById'],
      subtasks: List<String>.from(map['subtasks'] ?? []),
      date: date,
      time: time,
      reminderOption: map['reminderOption'] ?? "No Reminder",
    );
  }
}

class MainProvider extends ChangeNotifier {
  List<Reminder> reminders = [];
  final CollectionReference ref = FirebaseFirestore.instance.collection("Tasks");

  MainProvider() {
    fetchReminders();
  }

  // ------------------ REMINDERS ------------------

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

  // ------------------ DATE / TIME / REMINDER OPTION ------------------
  String selectedReminder = "30 min Before";

  void setSelectedReminder(String value) {
    selectedReminder = value;
    notifyListeners();
  }

  Future<void> updateReminderDate(String id, DateTime date) async {
    final reminder = reminders.firstWhere((r) => r.id == id);
    reminder.date = date;
    notifyListeners();

    await ref.doc(id).update({'date': Timestamp.fromDate(date)});
  }

  Future<void> updateReminderTime(String id, Duration time) async {
    final reminder = reminders.firstWhere((r) => r.id == id);
    reminder.time = time;
    notifyListeners();

    await ref.doc(id).update({'time': time.inSeconds});
  }

  Future<void> updateReminderOption(String id, String option) async {
    final reminder = reminders.firstWhere((r) => r.id == id);
    reminder.reminderOption = option;
    notifyListeners();

    await ref.doc(id).update({'reminderOption': option});
  }




  // Nihal
  TextEditingController usernameControler = TextEditingController();
  TextEditingController contactnumberControler = TextEditingController();

  FirebaseFirestore Db = FirebaseFirestore.instance;

  Future<bool> addcontact() async {
    // Generate unique key for contact
    String Key = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Save to Firebase with custom ID
      await Db.collection("contacts").doc(Key).set({
        "User_id": Key,
        "Added_ Time ":DateTime.now(),
        "name": usernameControler.text.trim(),
        "number": contactnumberControler.text.trim(),
      });

      // Add to local list instantly
      contactList.insert(
        0,
        Contact(
          id: Key, // use your custom ID
          username: usernameControler.text.trim(),
          userContactNumber: contactnumberControler.text.trim(),
        ),
      );

      notifyListeners();

      // Clear controllers
      usernameControler.clear();
      contactnumberControler.clear();

      return true;

    } catch (e) {
      print("Error adding contact: $e");
      return false;
    }
  }
  //fetch Function for
  int tempCheckedList=-1;
  void changeAddContact(int index){
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
  Future<bool> assignTask(Reminder reminder) async {
    if (tempCheckedList == -1) return false;

    final selected = contactList[tempCheckedList];
    final taskId = reminder.id;
    final contactId = selected.id;

    // 🔥 CHECK IF CONTACT ALREADY ASSIGNED
    bool alreadyAssigned = await isContactAssigned(contactId);
    if (alreadyAssigned) {
      print("Contact already assigned to a task");
      return false;   // IMPORTANT → return false
    }

    // ➤ Assign to CONTACT
    await Db.collection("contacts")
        .doc(contactId)
        .collection("assignedTasks")
        .doc(taskId)
        .set({
      "taskId": taskId,
      "taskText": reminder.taskText,
      "assignedTime": DateTime.now(),
    });

    // ➤ Assign to TASK
    await Db.collection("Tasks")
        .doc(taskId)
        .update({
      "taskAssignedToId": contactId,
      "taskAssignedToName": selected.username,
      "assignedTime": DateTime.now(),
    });

    print("Task assigned successfully!");
    return true;
  }


  Future<bool> isContactAssigned(String contactId) async {
    final snap = await Db
        .collection("contacts")
        .doc(contactId)
        .collection("assignedTasks")
        .get();

    return snap.docs.isNotEmpty; // true = already assigned
  }








}
