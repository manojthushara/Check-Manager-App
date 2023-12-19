import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../sub_pages/get_delete.dart';

class DeleteChPage extends StatefulWidget {


  @override
  State<DeleteChPage> createState() => _DeleteChPageState();
}

class _DeleteChPageState extends State<DeleteChPage> {

  List<String> docIDs = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCheView();
  }

  Future<void> getCheView() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cheques')
          .orderBy('cheques_date')
          .get();

      setState(() {
        docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error, e.g., show an error message to the user
    }
  }

  Future<void> autoDeleteCheques() async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime thresholdDate = currentDate.subtract(Duration(days: 2));

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
        title: const Text('Delete Cheques'),
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
              SizedBox(height: 5,),

              Container(
                height: 700,
                width: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    Expanded(
                      child: docIDs.isEmpty
                          ? const Center(child: CircularProgressIndicator(color: Colors.black,))
                          : ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 05),
                            child: ListTile(
                              title: GetCheDeletePage(documentId: docIDs[index],),
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
