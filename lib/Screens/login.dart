import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitledchat/Screens/mainscreen.dart';

import '../utils/ToastUtils.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Hello World'),),
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
            ElevatedButton(
                onPressed: () {
                  loginwithmail(_email.text, _password.text);
                },
                child: Text('Sign Up'))
          ],

        ),
      ),
    );
  }

  Future<void> loginwithmail(String email, String password) async {
    try {
      final login = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      ToastUtils.showtoast('Congratualtions.');
Get.to(mainscreen());

    }catch(e)
    {

        ToastUtils.showtoast('No user found for that email.');

    }
  }
}
