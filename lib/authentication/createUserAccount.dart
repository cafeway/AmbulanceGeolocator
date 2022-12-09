// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  _RegisterUserDemoState createState() => _RegisterUserDemoState();
}

class _RegisterUserDemoState extends State<RegisterUser> {
  // text editing controllers
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController contact = TextEditingController();
  //check for user

  // ignore: empty_constructor_bodie
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register To Get Services"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.blue,
                      size: 80.0,
                    )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(),
                    labelText: 'User Email Address',
                    hintText: 'e.g Paul@gmail.com'),
              ),
            ),
            //   const SizedBox(
            //   height: 40.0,
            // ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 10.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Jane Doe'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 10.0),
              child: TextField(
                controller: contact,
                decoration: InputDecoration(
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: '0722.....77'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10.0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Account Password',
                    hintText: 'Enter secure password'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 10.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FloatingActionButton(
                onPressed: () {
                  if (email.text == '') {
                    scaffold.showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content: const Text('Enter an Email')));
                  } else if (password.text == '') {
                    scaffold.showSnackBar(SnackBar(
                      content: const Text('Enter a Password'),
                      backgroundColor: Colors.blue,
                    ));
                  } else {
                    try {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password.text)
                          .then((value) => FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(value.user!.email)
                                  .set({
                                'Username': username.text,
                                'Email': email.text,
                                'role': 'user',
                                'phonenumber': contact.text,
                              }).then((value) =>
                                      Navigator.pushNamed(context, 'login')));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "Firebase_auth/user-not-found") {
                        // scaffold.showSnackBar(SnackBar(
                        //   content:
                        //       const Text('No user Found with that email'),
                        //   backgroundColor: Colors.blue,
                        // ));
                        print("user-not-found");
                      } else {
                        scaffold.showSnackBar(SnackBar(
                          content: const Text('wrong Password'),
                          backgroundColor: Colors.blue,
                        ));
                      }
                    }
                  }
                  print(email.text);
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
