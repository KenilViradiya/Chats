import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:untitledchat/Screens/chatscreen.dart';
import 'package:untitledchat/Screens/signin.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({super.key});

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  // Get reference to the Firestore collection
  final CollectionReference firestore =
      FirebaseFirestore.instance.collection("User");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder(
        stream: firestore.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (streamSnapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          } else if (!streamSnapshot.hasData ||
              streamSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final ds = streamSnapshot.data!.docs;

            return ListView.builder(
              itemCount: ds.length,
              itemBuilder: (context, index) {
                final user = ds[index];
                final name = user['Name'];
                final email = user['Email'];
                final id = user.id;

                return ListTile(
                  title: Text(name),
                  subtitle: Text(email),
                  onTap: () {
                    Get.to(chatscreen(receiverid: id, receivername: name));
                  },
                );
              },
            );

          }

        },

      ),

    );
  }

  void _logout() async{
    await FirebaseAuth.instance.signOut();
    Get.offAll(signin());
  }
}
