import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMedicineName extends StatelessWidget {
  final String documentId;

  GetMedicineName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference medicines =
        FirebaseFirestore.instance.collection('medicines');

    return FutureBuilder<DocumentSnapshot>(
      future: medicines.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;
          String name = data?['name'] ?? "";
          String date = data?['time'] ?? "";
          return Text("$name $date");
        }
        return Text('loading..');
      }),
    );
  }
}
