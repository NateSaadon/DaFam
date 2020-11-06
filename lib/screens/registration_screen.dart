import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/button_widget.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _fireStore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Username',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 2.0, left: 10),
                    child: Icon(
                      Icons.account_circle,
                      size: 28.0,
                      color: Color.fromARGB(150, 86, 195, 187),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 12.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  if (value != null) {}
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 2.0, left: 10),
                    child: Icon(
                      Icons.lock,
                      size: 25.0,
                      color: Color.fromARGB(150, 86, 195, 187),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              ButtonWidget(
                colour: Color.fromARGB(150, 86, 195, 187),
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    /*final CollectionReference postsRef =
                        FirebaseFirestore.instance.collection('/posts');

                    var postID = '1';

                    User post = new User(postID, "title", "content");
                    Map<String, dynamic> postData = post.toJson();
                    await postsRef.doc(postID).setData(postData);*/

                    _fireStore
                        .collection('users')
                        .doc("${_auth.currentUser.uid}")
                        .set({
                      'email': email,
                      'id': 'jnwdkfjn',
                      'photoURL':
                          'https://upload.wikimedi  a.org/wikipedia/commons/b/b2/Hausziege_04.jpg',
                      'username': username,
                    });

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
