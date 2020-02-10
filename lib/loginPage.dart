import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'modelClassesForEvent.dart';
import 'gradients.dart';
import 'profilePage.dart';
import 'chooseEventScreen.dart';

abstract class ControlInterface {
  _changeUiForLoading();
  _errorOccurred();
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin
    implements ControlInterface {
  double _height = 450.0;
  double _width = 450.0;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _email;
  final firebaseAuth = FirebaseAuth.instance;
  int orientation;
  bool found = false;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      orientation = 1;
    } else {
      orientation = 0;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: (orientation == 0) ? body(20, 10, 10) : body(10, 7, 7));
  }

  Widget body(double sizedBoxHeight, double margin, double paddingForText) {
    return Container(
      decoration: appGradient,
      child: Center(
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeOutCubic,
            height: _height,
            width: _width,
            margin: EdgeInsets.all(margin),
            child: Card(
              color: Color.fromARGB(255, 253, 253, 253),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(paddingForText),
                          child: Align(
                            child: Text(
                              "Please log into your account.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 40),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        SizedBox(
                          height: sizedBoxHeight,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              UserFormFields(
                                  "Email",
                                  Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 149, 208, 158),
                                  ),
                                  false,
                                  1,
                                  _emailController,
                                  this),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (_isLoading)
                            ? LoginLoader()
                            : LoginButton(
                                _isLoading,
                                _height,
                                this,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  _changeUiForLoading() {
    setState(() {
      _height = 425;
      _isLoading = true;
      if (_formKey.currentState.validate()) {
        _email = _emailController.text;
        doFirebaseQuery(
          _email,
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();

  }

  doFirebaseQuery(String email) async {
    try {
      QuerySnapshot qs = await Firestore.instance.collection("event").where("employeeIdEmailList",arrayContains: email).getDocuments();
      (qs.documents.length>0)?found = true:found =false;
      if (found) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ShowEventsScreen(email)));
      }

      if (email.length != null) {
        setState(() {
          _height = 450;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
        _height = 450;
      });
    }
  }


  @override
  _errorOccurred() {
    setState(() {
      _height = 450;
      _isLoading = false;
    });
  }
}

class LoginLoader extends StatefulWidget {
  @override
  _LoginLoaderState createState() => _LoginLoaderState();
}

class _LoginLoaderState extends State<LoginLoader> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(seconds: 1),
      padding: EdgeInsets.all(20),
      child:
          SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
    );
  }
}

class LoginButton extends StatefulWidget {
  final bool isLoading;
  final double height;
  final ControlInterface mListener;
  LoginButton(this.isLoading, this.height, this.mListener);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 60,
      child: Card(
        elevation: 10,
        color: Color.fromARGB(255, 149, 208, 158),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: () {
            widget.mListener._changeUiForLoading();
          },
          child: Center(
              child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class UserFormFields extends StatefulWidget {
  final String text;
  final Icon icon;
  final bool isObscure;
  final int detect;
  final controller;
  final ControlInterface mListener;
  UserFormFields(this.text, this.icon, this.isObscure, this.detect,
      this.controller, this.mListener);

  @override
  _UserFormFieldsState createState() =>
      _UserFormFieldsState(this.text, this.icon, this.isObscure, this.detect);
}

class _UserFormFieldsState extends State<UserFormFields> {
  final String text;
  final Icon icon;
  bool isObscure;
  int detectEmailOrPassword; // 0 for password 1 for email
  _UserFormFieldsState(
      this.text, this.icon, this.isObscure, this.detectEmailOrPassword);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            widget.mListener._errorOccurred();
            return "Please enter a valid employee ID ";
          }
          return null;
        },
        controller: widget.controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: text,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 149, 208, 158))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 149, 208, 158))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 149, 208, 158))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue)),
          prefixIcon: icon,
          suffixIcon: IconButton(
            icon: Icon(
              (detectEmailOrPassword == 0) ? Icons.remove_red_eye : null,
              color: (isObscure)
                  ? Color.fromARGB(255, 149, 208, 158)
                  : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
        ),
      ),
    );
  }
}
