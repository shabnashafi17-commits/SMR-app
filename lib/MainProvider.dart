import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_class.dart';
import 'package:audioplayers/audioplayers.dart';

class Reminder {
  String id;
  String? taskText;
  String? taskVoice;
  String taskType;
  DateTime createdAt;
  String createdBy;
  String createdById;
  List<String> subtasks;
  DateTime? date;
  Duration? time;
  String reminderOption;
  String? taskAssignedToId;
  String? taskAssignedToName;
  String? taskStatus;
  int voiceCount;

  // NOT Duration

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
    this.taskAssignedToId,
    this.taskAssignedToName,
    this.taskStatus = "start",
    required this.voiceCount,
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
      'taskAssignedToId': taskAssignedToId,
      'taskAssignedToName': taskAssignedToName,
      'taskStatus': taskStatus,
      'voiceCount': voiceCount,

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
      taskAssignedToId: map['taskAssignedToId'],
      taskAssignedToName: map['taskAssignedToName'],
      taskStatus: map['taskStatus'] ?? "start",

      // ✅ READ from Firestore
      voiceCount: map['voiceCount'] ?? 1,
    );
  }


}

class MainProvider extends ChangeNotifier {
  String? currentUserId;
  List<Reminder> reminders = [];
  final CollectionReference ref = FirebaseFirestore.instance.collection(
    "Tasks",
  );
  // 🔊 AUDIO STATE (GLOBAL)
  String? currentAudio;
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();


  MainProvider() {
    fetchReminders();

    audioPlayer.onPlayerComplete.listen((event) {
      currentAudio = null;
      isPlaying = false;
      notifyListeners();
    });
  }


  // ------------------ REMINDERS ------------------

  Future<void> fetchReminders() async {
    try {
      // Fetch only tasks with status "start"
      final snap = await ref
          .where("taskStatus", isEqualTo: "start")
          .orderBy("createdAt", descending: true)
          .get();

      reminders = snap.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        data["id"] = e.id;
        return Reminder.fromMap(data);
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching active reminders: $e");
    }
  }


  Future<void> addTextReminder(String text) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newReminder = Reminder(
      id: id,
      taskText: text,
      taskVoice: null,
      taskType: "text",
      taskStatus: "start",
      createdAt: DateTime.now(),
      createdBy: "Admin",
      createdById: "USER_001",
      voiceCount: 0,


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
      taskStatus: "start",
      createdAt: DateTime.now(),
      createdBy: "Admin",
      createdById: "USER_001",
      voiceCount: nextVoiceCount ,

    );
    await ref.doc(id).set(newReminder.toMap());
    reminders.insert(0, newReminder);
    notifyListeners();
  }

  Future<void> addSubtaskToReminder(String reminderId, String text) async {
    if (text.trim().isEmpty) return;

    final index = reminders.indexWhere((r) => r.id == reminderId);
    if (index == -1) return;

    // Create a new modifiable list
    final updatedList = List<String>.from(reminders[index].subtasks)
      ..add(text.trim());

    // Replace old subtasks list
    reminders[index].subtasks = updatedList;

    notifyListeners();

    try {
      await ref.doc(reminderId).update({'subtasks': updatedList});
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

  Future<void> completeTask(Reminder reminder,int index) async {
    final taskId = reminder.id;

    // Update task in Firestore
    await Db.collection("Tasks").doc(taskId).update({
      "Completed_date": DateTime.now(),
      "taskStatus": "Completed",
    });
    reminders.removeAt(index);
    reminder.taskStatus = "Completed";
    notifyListeners();
  }


  List<Reminder> completedTasks = [];

  Future<void> fetchCompletedTasks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Tasks")
          .where("taskStatus", isEqualTo: "Completed")
          .get();

      completedTasks = snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime? completedDate;
        Duration? completedTime;
        

        if (data["Completed_date"] != null) {
          completedDate =
              (data["Completed_date"] as Timestamp).toDate();

          completedTime = Duration(
            hours: completedDate.hour,
            minutes: completedDate.minute,
          );
        }

        return Reminder(
          id: doc.id,
          taskText: data["taskText"],
          taskVoice: data["taskVoice"],
          taskType: data["taskVoice"] != null &&
              data["taskVoice"].toString().isNotEmpty
              ? "voice"
              : "text",

          createdAt: (data["createdAt"] as Timestamp).toDate(),
          createdBy: data["createdBy"],
          createdById: data["createdById"],
          subtasks: List<String>.from(data["subtasks"] ?? []),

          // ✅ USE COMPLETED DATE & TIME
          date: completedDate,
          time: completedTime,

          reminderOption: data["reminderOption"] ?? "No Reminder",
          taskAssignedToId: data["taskAssignedToId"],
          taskAssignedToName: data["taskAssignedToName"],
          taskStatus: data["taskStatus"],
          voiceCount: data['voiceCount'] ?? 1,

        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching completed tasks: $e");
    }
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
        "Added_ Time ": DateTime.now(),
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
  int tempCheckedList = -1;

  void changeAddContact(int index) {
    if (index == tempCheckedList) {
      tempCheckedList = -1;
    } else {
      tempCheckedList = index;
    }
    notifyListeners();
  }

  List<Contact> contactList = [];

  Future<void> fetchContacts() async {
    try {
      contactList.clear();

      var snapshot = await FirebaseFirestore.instance
          .collection("contacts")
          .get();

      for (var doc in snapshot.docs) {
        contactList.add(
          Contact(
            id: doc.id,
            username: doc['name'] ?? '',
            userContactNumber: doc['number'] ?? '',
          ),
        );
      }
      contactList = contactList.reversed.toList();
      print(contactList.length.toString() + "jghjgh");

      notifyListeners();
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

  Future<void> _assignToFirestore(
    Reminder reminder,
    String contactId,
    String username,
  ) async {
    final taskId = reminder.id;

    // Save in contact assignedTasks
    await Db.collection(
      "contacts",
    ).doc(contactId).collection("assignedTasks").doc(taskId).set({
      "taskId": taskId,
      "taskText": reminder.taskText,
      "assignedTime": DateTime.now(),
    });

    // Update task master record
    await Db.collection("Tasks").doc(taskId).update({
      "taskAssignedToId": contactId,
      "taskAssignedToName": username,
      "assignedTime": DateTime.now(),
      "taskStatus": "assignTask",
    });

    // Update local object
    reminder.taskAssignedToId = contactId;
    reminder.taskAssignedToName = username;
    reminder.taskStatus = "assignTask";

    notifyListeners();
  }

  List<Reminder> userAssignedTasks = [];

  bool isAssignedMode = false;

  Future<void> fetchAssignedTasks(String contactId) async {
    QuerySnapshot snap = await Db.collection(
      "contacts",
    ).doc(contactId).collection("assignedTasks").get();

    userAssignedTasks = snap.docs.map((doc) {
      return Reminder(
        id: doc["taskId"],
        taskText: doc["taskText"],
        taskVoice: null,
        taskType: "text",
        // default
        createdAt: DateTime.now(),
        // no value in DB
        createdBy: "unknown",
        // required
        createdById: "unknown",
        // required
        subtasks: [],
        date: null,
        time: null,
        reminderOption: "No Reminder",
        taskAssignedToId: contactId,
        taskAssignedToName: "",
        taskStatus: "assignTask",
        voiceCount:0,

      );
    }).toList();

    notifyListeners();
  }

  Future<void> assignTask(Reminder reminder) async {
    if (tempCheckedList == -1) return;

    final selected = contactList[tempCheckedList];
    final newContactId = selected.id;

    // If this task is already assigned to someone else
    if (reminder.taskAssignedToId != null &&
        reminder.taskAssignedToId!.isNotEmpty &&
        reminder.taskAssignedToId != newContactId) {
      final oldAssignedName = reminder.taskAssignedToName ?? "another person";
      return;
    }
    // If not assigned, assign normally
    await _assignToFirestore(reminder, selected.id, selected.username);
  }

  Future<bool> replaceAssignedTask(
    Reminder reminder,
    String newContactId,
    String newName,
  ) async {
    print("Replacing assignment...");

    final oldContactId = reminder.taskAssignedToId;

    // Remove from old assigned user
    if (oldContactId != null && oldContactId.isNotEmpty) {
      await Db.collection(
        "contacts",
      ).doc(oldContactId).collection("assignedTasks").doc(reminder.id).delete();

      print("Removed task from old assigned user: $oldContactId");
    }

    // Add to new assigned user
    await Db.collection(
      "contacts",
    ).doc(newContactId).collection("assignedTasks").doc(reminder.id).set({
      "taskId": reminder.id,
      "taskText": reminder.taskText,
      "assignedTime": DateTime.now(),
    });

    // Update global Tasks collection
    await Db.collection("Tasks").doc(reminder.id).update({
      "taskAssignedToId": newContactId,
      "taskAssignedToName": newName,
      "assignedTime": DateTime.now(),
      "taskStatus": "assignTask",
    });

    // Update local object
    reminder.taskAssignedToId = newContactId;
    reminder.taskAssignedToName = newName;

    // Refresh UI
    notifyListeners();

    print("Task replaced successfully!");

    return true; // successfully replaced
  }
  int get nextVoiceCount {
    final voiceReminders =
    reminders.where((r) => r.taskType == "voice").toList();
    return voiceReminders.length + 1;
  }
  Future<void> playAudio(String path) async {
    // Stop previous audio
    await audioPlayer.stop();

    currentAudio = path;
    isPlaying = true;
    notifyListeners();

    await audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();

    currentAudio = null;
    isPlaying = false;
    notifyListeners();
  }


}
