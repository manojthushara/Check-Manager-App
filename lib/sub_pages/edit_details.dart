import 'package:flutter/material.dart';

import 'edit_ch_details.dart';

class EditCheDetailsPage extends StatelessWidget {
  final String documentId;

  EditCheDetailsPage({required this.documentId});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Delete Cheques'),
        backgroundColor: Colors.black12,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
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
                  SizedBox(height: 20,),

                  EditCheDetails(documentId: documentId,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
