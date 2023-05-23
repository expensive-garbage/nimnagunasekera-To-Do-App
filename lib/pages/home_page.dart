// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/custom/todo_card.dart';
import 'package:todo/pages/add_todo.dart';
import '../service/auth_service.dart';
// import 'sign_up_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Today's Tasks",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/avatar.png"),
          ),
          SizedBox(
            width: 25,
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22),
              child: Text(
                "Monday 21",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
          ),
        ),
      ),

      //Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Colors.indigoAccent,
                    Colors.purpleAccent,
                  ]),
                ),
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: "Add",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: "Settings",
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  switch (document["category"]) {
                    case "Food":
                      iconData = Icons.local_grocery_store_outlined;
                      iconColor = Color(0xffff6d6e);
                      break;
                    case "Work":
                      iconData = Icons.work_outline_outlined;
                      iconColor = Color(0xff6557ff);
                      break;
                    case "Workout":
                      iconData = Icons.fitness_center_outlined;
                      iconColor = Color(0xfff29732);
                      break;
                    case "Design":
                      iconData = Icons.design_services_outlined;
                      iconColor = Color(0xff234ebd);
                      break;
                    case "Run":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Color(0xff2bc8d9);
                      break;
                    default:
                      iconData = Icons.task_alt_outlined;
                      iconColor = Colors.blue;
                  }
                  return TodoCard(
                    // ignore: prefer_if_null_operators
                    title: document["title"] == null ? "" : document["title"],
                    check: true,
                    iconBgColor: Colors.white,
                    iconColor: iconColor,
                    iconData: iconData,
                    time: "10 AM",
                  );
                });
          }),
    );
  }
}

//For future use
//  IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: () async {
//                 await authClass.logout();
//                 // ignore: use_build_context_synchronously
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (builder) => const SignUpPage()),
//                     (route) => false);
//               })
