import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../componuts/button.dart';
import '../componuts/my_textfeild01.dart';

class EditCheDetails extends StatefulWidget {
  final String documentId;

  EditCheDetails({required this.documentId});

  @override
  _EditCheDetailsState createState() => _EditCheDetailsState();
}

class _EditCheDetailsState extends State<EditCheDetails> {
  final nameController = TextEditingController();
  final noController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();


  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  CollectionReference buses = FirebaseFirestore.instance.collection('Cheques');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: buses.doc(widget.documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [

              //name
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'Name:',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              MyTextField01(
                controller: nameController..text = '${data['cheques_name']}',
                hintText: 'Name ',
                obscureText: false,
                initialValue: '${data['cheques_name']}',
              ),

              SizedBox(height: 20),

              //no
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'No:',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              MyTextField01(
                controller: noController..text = '${data['cheques_no']}',
                hintText: 'No ',
                obscureText: false,
                initialValue: '${data['cheques_no']}',
              ),

              SizedBox(height: 20),

            //date
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'Date:',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      '${_formatDate(data['cheques_date'] as Timestamp)}',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ],
              ),

              //select date
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        backgroundColor: Colors.black12),

                    child: const Text('Select Date',style:
                    TextStyle(fontSize: 16,
                        color: Colors.white),),
                  ),

                  SizedBox(height: 10,),

                  Text("${selectedDate.toLocal()}".split(' ')[0],style: TextStyle(
                  ),),

                ],
              ),

              SizedBox(height: 20),

              // amount
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'Amount:',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              MyTextField01(
                controller: amountController..text = '${data['cheques_amount']}',
                hintText: 'Amount ',
                obscureText: false,
                initialValue: '${data['cheques_amount']}',
              ),

              SizedBox(height: 20),

              //update button
              MyButton(
                text: "Update",
                onTop: update
              ),


              SizedBox(height: 20),

              // cancel button
              MyButton(
                text: "Cancel",
                onTop: (){
                  Navigator.pop(context);
                },
              ),

            ],
          );
        }

        // Loading process
        return Center(
          child: CircularProgressIndicator(
            color: Colors.black,
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

  @override
  void dispose() {
    nameController.dispose();
    noController.dispose();
    dateController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // Update Details Button
  void update() async {
    try {
      await updateUserDetails(
        nameController.text.trim(),
        int.parse(noController.text.trim()),
        double.parse(amountController.text.trim()),
        selectedDate,
      );
      print('Details updated successfully');
      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details updated successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blueAccent,// Duration for which Snackbar is displayed
        ),
      );
    } catch (error) {
      print('Error updating details: $error');
      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update Failed'),
          duration: Duration(seconds: 2), // Duration for which Snackbar is displayed
        ),
      );

    }
  }

  Future<void> updateUserDetails(String name, int no, double amount, DateTime date) async {
    await FirebaseFirestore.instance.collection('Cheques').doc(widget.documentId).update(
      {
        'cheques_name': name,
        'cheques_amount': amount,
        'cheques_no': no,
        'cheques_date': date,
      },
    );
    print('Details updated...');
  }


}
