// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder_app/service/get_medicine_name.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

const List<String> list = <String>[
  'Tablet',
  'Pill',
  'Cream/Gel',
  'Syringe',
  'Syrup',
];

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  String takingTime = '';
  late DateTime _selectedDate;
  late final user = FirebaseAuth.instance.currentUser;
  var collection = FirebaseFirestore.instance.collection("medicines");
  List<String> medIDs = [];

  Future<void> getMedId() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("medicines")
        .where("userID", isEqualTo: user?.uid)
        .orderBy("time")
        .get();
    setState(() {
      medIDs = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  triggerNotification(var time, String name, String type) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'basic_chanel',
          title: 'Time to Take $name ',
          wakeUpScreen: true,
          autoDismissible: false,
          body: "Hi ${user!.displayName}. It's $time, it's time to take $name ",
        ),
        schedule: NotificationCalendar(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1]),
          second: 0,
          millisecond: 0,
          allowWhileIdle: true,
          preciseAlarm: true,
          repeats: true,
        ));
  }

  String dropDownValue = list.first;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    getMedId();
  }

  void _addOneDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  void _subtractOneDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  void _goToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void addPopup() {
    if (_selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert!'),
              content: Text("You can't add medicine before today's date"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
          context: context);
      //Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a new Medicine'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.00, right: 25, top: 25),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 95, 76, 221),
                                width: 2.0),
                          ),
                          labelText: 'Medicine Name',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 50, 30, 80))),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButton<String>(
                    value: dropDownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    onChanged: (String? value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 36.0),
                  TimePickerSpinner(
                    is24HourMode: true,
                    minutesInterval: 1,
                    normalTextStyle:
                        TextStyle(fontSize: 12, color: Colors.black),
                    highlightedTextStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    spacing: 10,
                    itemHeight: 20,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      setState(() {
                        takingTime = DateFormat.Hm().format(time);
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 23)),
              ElevatedButton(
                child: Text('ADD'),
                onPressed: () async {
                  String date =
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
                  try {
                    await FirebaseFirestore.instance
                        .collection("medicines")
                        .add({
                      "name": nameController.text,
                      "type": dropDownValue,
                      "time": takingTime,
                      "date": date,
                      "userID": user?.uid,
                    });
                    getMedId();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } catch (e, stackTrace) {
                    print('Error adding data to Firestore: $e');
                    print(stackTrace);
                    _throw(e, stackTrace);
                  }
                  nameController.text = "";
                },
              ),
            ],
          );
        },
      );
    }
  }

  void updatePopup(String id) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Medicine'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        InputDecoration(hintText: 'Enter New Medicine name'),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButton(
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: list.map((String types) {
                        return DropdownMenuItem(
                          value: types,
                          child: Text(types),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      }),
                  SizedBox(height: 36.0),
                  TimePickerSpinner(
                    is24HourMode: true,
                    minutesInterval: 1,
                    normalTextStyle:
                        TextStyle(fontSize: 12, color: Colors.black),
                    highlightedTextStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    spacing: 10,
                    itemHeight: 20,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      setState(() {
                        takingTime = DateFormat.Hm().format(time);
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('UPDATE'),
                onPressed: () async {
                  String date =
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
                  try {
                    await FirebaseFirestore.instance
                        .collection("medicines")
                        .doc(id)
                        .update({
                      "name": nameController.text,
                      "type": dropDownValue,
                      "time": takingTime,
                      "date": date,
                      "userID": user?.uid,
                    });

                    getMedId();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } catch (e, stackTrace) {
                    print('Error adding data to Firestore: $e');
                    print(stackTrace);
                    _throw(e, stackTrace);
                  }
                  nameController.text = "";
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/BGlogo.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              child: InkWell(
                splashColor: colorScheme.secondary.withAlpha(400),
                onTap: () {
                  _goToday();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        size: 45,
                      ),
                      onPressed: _subtractOneDay,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 230,
                          height: 45,
                          child: Center(
                            child: Text(
                              DateFormat('dd MMMM y, EEE')
                                  .format(_selectedDate),
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        size: 45,
                      ),
                      onPressed: _addOneDay,
                    ),
                  ],
                ),
              ),
            ),
            getMedicineList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: colorScheme.secondary,
                  onPressed: () {
                    addPopup();
                  },
                  icon: Icon(Icons.add_circle),
                  iconSize: 60,
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 35)),
          ],
        ),
      ),
    );
  }

  Container getMedicineList() {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onBackground,
            blurRadius: 8,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      width: 300.0,
      height: 400.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(10)),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: medIDs.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8.0),
                              Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      key: ValueKey(GetMedicineName(documentId: medIDs[index])),
                      confirmDismiss: (DismissDirection direction) async {
                        if (direction == DismissDirection.endToStart) {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Confirmation"),
                                content: const Text(
                                    "Are you sure you want to delete this Medicine?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Delete")),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return true;
                        }
                      },
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          updatePopup(medIDs[index]);
                        } else {
                          DocumentReference documentReference =
                              collection.doc(medIDs[index]);

                          documentReference.delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(' Medicine dismissed')));
                        }
                      },
                      child: ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.notifications_on_rounded),
                            onPressed: () async {
                              var document = FirebaseFirestore.instance
                                  .collection('medicines')
                                  .doc(medIDs[index]);
                              var snapshot = await document.get();
                              var time = snapshot.data()!['time'];
                              var name = snapshot.data()!['name'];
                              var type = snapshot.data()!['type'];
                              triggerNotification(time, name, type);
                            },
                          ),
                          title: GetMedicineName(documentId: medIDs[index])),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Never _throw(Object error, StackTrace stackTrace) {
  print("An error occurred: $error");
  print(stackTrace);
  throw error;
}
