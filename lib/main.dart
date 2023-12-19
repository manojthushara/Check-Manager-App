import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'main_pages/add_page.dart';
import 'main_pages/delete_page.dart';
import 'main_pages/edit_page.dart';
import 'main_pages/today_che_page.dart';
import 'main_pages/view_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 20,),

              //main logo
              Container(
                margin: EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 10),
                child: Image.asset('lib/images/mainlogo.png'),
                height: 170,
                width: 170,
              ),

              //main text
              const Text('MJS Stores Cheques Manager',style:
              TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold
              ),),

              SizedBox(height: 20,),

              //main menu
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: Colors.black12,
                ),
                height: 625,
                width: 380,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodayCheViewPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 340,
                        child: Row(
                          children: [

                            //image
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Image.asset('lib/images/today.png'),
                              height: 65,
                              width: 65,
                            ),

                            //text
                            Container(
                              width: 200,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Today Cheques',style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),

                            //arrow
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    //add buttons
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddChPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 340,
                        child: Row(
                          children: [

                            //image
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Image.asset('lib/images/add.png'),
                              height: 65,
                              width: 65,
                            ),

                            //text
                            Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text('Add Cheques',style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),

                            //arrow
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    // view button
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewChPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 340,
                        child: Row(
                          children: [

                            //image
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Image.asset('lib/images/view.png'),
                              height: 70,
                              width: 70,
                            ),

                            //text
                            Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text('View Cheques',style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),

                            //arrow
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    //edit button
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditChePage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),

                        height: 100,
                        width: 340,
                        child: Row(
                          children: [

                            //image
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Image.asset('lib/images/edit.png'),
                              height: 70,
                              width: 70,
                            ),

                            //text
                            Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text('Edit Cheques',style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),

                            //arrow
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    // delete button
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteChPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 340,
                        child: Row(
                          children: [

                            //image
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Image.asset('lib/images/delete.png'),
                              height: 70,
                              width: 70,
                            ),

                            //text
                            Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text('Delete Cheques',style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),

                            //arrow
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: 415,
                height: 85,
                color: Colors.black,
                child: Center(
                  child: Text('Powered By Mouse Studio',style:
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
