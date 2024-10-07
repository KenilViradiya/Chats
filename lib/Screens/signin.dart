import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:untitledchat/Screens/mainscreen.dart';

import '../utils/ToastUtils.dart';

class signin extends StatelessWidget {
  signin({super.key});
final TextEditingController _email   =  TextEditingController();
final TextEditingController _password =  TextEditingController();
final TextEditingController _name  =  TextEditingController();
final FirebaseFirestore _firestore  =  FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signin'),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(label: Text('Enter Your Email')),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(label: Text('Enter Password')),
            ),
            TextField(
              controller: _name,
              decoration: InputDecoration(label: Text('Enter Name')),
            ),
            ElevatedButton(
                onPressed:()  {signupwithmail();
                  },
                child: Text('Sign Up')),

          ],

        ),
      ),

    );
  }

  Future<void> signupwithmail() async{
    QuerySnapshot emailquery = await _firestore.collection('User').where(
        'Email', isEqualTo: _email.text).get();
    QuerySnapshot namequery = await _firestore.collection('User').where(
        'Name', isEqualTo: _name.text).get();
    if (emailquery.docs.isNotEmpty) {
     return  ToastUtils.showtoast('Email is Not Unique');
    }
    if (namequery.docs.isNotEmpty) {
     return ToastUtils.showtoast('Name is Not Unique');
    }
    else {
      try {
        final auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
        await _firestore.collection('User').doc().set({
          'Email': _email.text,

          'Name': _name.text
        });
        ToastUtils.showtoast('Congrats Succesfully Register');
        Get.to(mainscreen());
      }
      catch (e) {
        ToastUtils.showtoast('Something Wrong');
      }
    }
  }


}
