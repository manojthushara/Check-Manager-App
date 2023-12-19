import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../componuts/button.dart';
import '../componuts/textfeild01.dart';

class AddChPage extends StatefulWidget {

  @override
  State<AddChPage> createState() => _AddChPageState();
}

class _AddChPageState extends State<AddChPage> {

  final chnoController = TextEditingController();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    chnoController.dispose();
    amountController.dispose();
    nameController.dispose();
    super.dispose();
  }

  //add cheques on firebase
  void addche() async {
      addDetails(
        int.parse(chnoController.text.trim()),
        double.parse(amountController.text.trim()),
        nameController.text.trim(),
        selectedDate,
      );

  }

  Future<void> addDetails(int chno, double amount, String name, DateTime date) async {
    try {
      await FirebaseFirestore.instance.collection('Cheques').add(
        {
          'cheques_no': chno,
          'cheques_amount': amount,
          'cheques_name': name,
          'cheques_date': date,
        },
      );
      print('Data added successfully');
      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cheques Added..!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.cyan,// Duration for which Snackbar is displayed
        ),
      );
    } catch (e) {
      print('Error adding data: $e');
    }
  }

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

  bool _isCheckingCheNumber = false;
  bool _isCheNumberAvailable = true;

  Future<void> _checkCheNumberAvailability(String cheno) async {
    if (_isCheckingCheNumber) {
      // If already checking, skip this invocation
      return;
    }

    try {
      setState(() {
        _isCheckingCheNumber = true;
      });

      int chenoInt = int.tryParse(cheno) ?? 0; // Default to 0 if conversion fails

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cheques')
          .where('cheques_no', isEqualTo: chenoInt)
          .get();

      setState(() {
        _isCheNumberAvailable = querySnapshot.docs.isEmpty;
        _isCheckingCheNumber = false;
      });

      print('Cheque number availability for $chenoInt: $_isCheNumberAvailable');
    } catch (error) {
      print('Error during Firestore query: $error');
      // Handle the error as needed
      setState(() {
        _isCheckingCheNumber = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cheques'),
        backgroundColor: Colors.black12,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                height: 750,
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                          child: Text('Cheques No:',style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),

                    MyTextField(
                        controller: chnoController,
                        hintText: 'Ex: 12345',
                        obscureText: false),

                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                          child: Text('Cheques Amount:',style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),

                    MyTextField(
                        controller: amountController,
                        hintText: 'Ex: 10000.00',
                        obscureText: false),

                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                          child: Text('Cheques Name:',style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),

                    MyTextField(
                        controller: nameController,
                        hintText: 'Ex: Manchee',
                        obscureText: false),

                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                          child: Text('Cheques Date:',style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${selectedDate.toLocal()}".split(' ')[0],style: TextStyle(
                          fontSize: 17,

                        ),),
                        const SizedBox(height: 20.0,),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 50),
                          backgroundColor: Colors.black12),

                          child: const Text('Select Date',style:
                            TextStyle(fontSize: 16,
                            color: Colors.white),),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    MyButton(
                      text: "Add",
                      onTop: () async {
                        String cheno = chnoController.text.trim();
                        String amount = amountController.text;
                        String chnamee = nameController.text;
                        String date = selectedDate.toString();
                        final chenoRE = RegExp(r'^[0-9]+$');
                        final cheamountRE = RegExp(r'^[0-9]+$');
                        final chenameRE = RegExp(r'^[a-zA-Z]+$');

                        // Check if the cheque number is available in Firestore
                        await _checkCheNumberAvailability(cheno);

                        if (cheno.isEmpty ||
                        amount.isEmpty ||
                        chnamee.isEmpty) {
                          // Show Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please Fill All Field.!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.redAccent,// Duration for which Snackbar is displayed
                            ),
                          );
                        } else if (chenoRE.hasMatch(cheno)) {
                          if (cheamountRE.hasMatch(amount)) {
                            if (chenameRE.hasMatch(chnamee)) {
                              if (_isCheNumberAvailable) {
                                // Cheque number is available, proceed to add the cheque
                                addche();
                              } else {
                                // Cheque number already exists, show a message to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Cheque Number Already Exists.'),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cheque Name is Wrong.!'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors
                                      .redAccent, // Duration for which Snackbar is displayed
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cheque Amount is Wrong.!'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors
                                    .redAccent, // Duration for which Snackbar is displayed
                              ),
                            );
                          }

                          } else {
                            // Show Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cheque Number is Wrong.!'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors
                                    .redAccent, // Duration for which Snackbar is displayed
                              ),
                            );
                          }
                      },
                    ),


                    SizedBox(height: 20,),

                    MyButton(
                      text: "Cancel",
                      onTop: (){
                        Navigator.pop(context);
                      },
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
