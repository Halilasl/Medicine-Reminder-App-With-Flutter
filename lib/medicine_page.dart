// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/MBGlogo.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(23.0),
            ),
            Container(
              height: 155,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
              ),
              padding: EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Text(
                    'TABLETS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('drugs')
                          .where('type', isEqualTo: 'tablet')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error fetching data');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final data = snapshot.data!.docs;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: data.map((doc) {
                              final name = doc['name'];
                              final explanation = doc['explanation'];
                              final link = doc['link'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 11.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(name),
                                          content: Text(explanation),
                                          actions: [
                                            TextButton(
                                              child: Text('Done'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        link,
                                        height: 100,
                                        width: 150,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 11, 3, 1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
            ),
            Container(
              height: 155,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
              ),
              padding: EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Text(
                    'SYRUPS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('drugs')
                          .where('type', isEqualTo: 'syrup')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error fetching data');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final data = snapshot.data!.docs;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: data.map((doc) {
                              final name = doc['name'];
                              final explanation = doc['explanation'];
                              final link = doc['link'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(name),
                                          content: Text(explanation),
                                          actions: [
                                            TextButton(
                                              child: Text('Done'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        link,
                                        height: 93,
                                        width: 150,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 11, 3, 1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
              ),
              padding: EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Text(
                    ' VACCINES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('drugs')
                          .where('type', isEqualTo: 'vaccine')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error fetching data');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final data = snapshot.data!.docs;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: data.map((doc) {
                              final name = doc['name'];
                              final explanation = doc['explanation'];
                              final link = doc['link'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(name),
                                          content: Text(explanation),
                                          actions: [
                                            TextButton(
                                              child: Text('Done'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        link,
                                        height: 100,
                                        width: 150,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 11, 3, 1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 33,
            )
          ],
        ),
      ),
    );
  }
}
