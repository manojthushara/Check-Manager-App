import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sub_pages/get_edit_page.dart';
import '../sub_pages/get_today_page.dart';

class TodayCheViewPage extends StatefulWidget {
  @override
  State<TodayCheViewPage> createState() => _TodayCheViewPageState();
}

class _TodayCheViewPageState extends State<TodayCheViewPage> {
  List<String> docIDs = [];
  double totalAmount = 0.0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    Map<String, dynamic> result = await getCheView();
    totalAmount = result['totalAmount'] as double;
    await autoDeleteCheques();
  }

  Future<Map<String, dynamic>> getCheView() async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime startOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cheques')
          .where('cheques_date', isGreaterThanOrEqualTo: startOfDay)
          .where('cheques_date', isLessThan: startOfDay.add(Duration(days: 1)))
          .orderBy('cheques_date')
          .get();

      // Calculate the total amount
      double totalAmount = querySnapshot.docs
          .map((doc) => doc['cheques_amount'] as double)
          .fold(0, (prev, amount) => prev + amount);

      setState(() {
        docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
        this.totalAmount = totalAmount;
      });

      return {'totalAmount': totalAmount};
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data. Please try again later.'),
        ),
      );
      return {'totalAmount': 0.0};
    }
  }

  Future<void> autoDeleteCheques() async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime thresholdDate = currentDate.subtract(Duration(days: 1));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cheques')
          .where('cheques_date', isLessThan: thresholdDate)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.delete();
      }

      // Optional: If you want to update the UI after deletion
      await getCheView();
    } catch (error) {
      print('Error auto-deleting data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error auto-deleting data. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today Cheques'),
        backgroundColor: Colors.black12,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 750,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Column(
                children: [

                  // che no
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      SizedBox(width: 30,),

                      Text('Date: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),

                      SizedBox(width: 60,),

                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate.toLocal()),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),

                  //che name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30,),
                      Text('Total: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),),
                      SizedBox(width: 55,),

                      Text(
                        '${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),

                ],
              ),

              Container(
                height: 650,
                width: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Expanded(
                      child: docIDs.isEmpty
                          ? const Center(
                        child: Text(
                          'No cheques for today.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      )
                          : ListView.builder(
                        key: UniqueKey(),
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              title: GetTodayChePage(
                                documentId: docIDs[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
