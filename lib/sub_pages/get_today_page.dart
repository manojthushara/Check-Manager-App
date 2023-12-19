import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../componuts/button2.dart';
import 'edit_details.dart';

class GetTodayChePage extends StatelessWidget {
  final String documentId;

  GetTodayChePage({required this.documentId});

  @override
  Widget build(BuildContext context) {

    //connection db
    CollectionReference buses = FirebaseFirestore.instance.collection('Cheques');

    return FutureBuilder<DocumentSnapshot>(
      future: buses.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            children: [

              // main menu
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                height: 130,

                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [

                      // che no
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(width: 25,),

                          Text('No: ',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),

                          SizedBox(width: 75,),

                          Text('${data['cheques_no']}',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),
                        ],
                      ),

                      SizedBox(height: 5,),

                      //che name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                          Text('Name: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),
                          SizedBox(width: 50,),

                          Text('${data['cheques_name']}',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),
                        ],
                      ),

                      SizedBox(height: 5,),

                      //che date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                          Text('Date: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),

                          SizedBox(width: 63,),

                          Text('${_formatDate(data['cheques_date'] as Timestamp)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),
                        ],
                      ),

                      SizedBox(height: 5,),

                      //che amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                          const Text('Amount: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),),

                          SizedBox(width: 35,),

                          Text(
                            '${(data['cheques_amount'] as double).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Loading process
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),
          height: 130,

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Function of date
  String _formatDate(Timestamp timestamp) {
    if (timestamp == null) {
      return 'Date not available';
    }

    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to display only the date part
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
