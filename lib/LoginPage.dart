import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ControlInterface {
  _changeUiForLoading();
  _errorOccurred();
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements ControlInterface {
  double _height = 450;
  double _width = 450;
  bool _isLoading = false;
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoading);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 0, 26, 71),
            Color.fromARGB(255, 149, 208, 158)
          ], begin: Alignment.center, end: Alignment(2.0, 1.5)),
        ),
        child: Center(
          child: AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeOutCubic,
              height: _height,
              width: _width,
              margin: EdgeInsets.all(10),
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
                            padding: EdgeInsets.all(15.0),
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
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                UserFormFields(
                                    "E-mail",
                                    Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 149, 208, 158),
                                    ),
                                    false,
                                    1,
                                    _emailTextController,
                                    this),
                                UserFormFields(
                                    "Password",
                                    Icon(Icons.lock,
                                        color:
                                            Color.fromARGB(255, 149, 208, 158)),
                                    true,
                                    0,
                                    _passwordTextController,
                                    this)
                              ],
                            ),
                          )
                        ],
                      ),
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
      ),
    );
  }

  @override
  _changeUiForLoading() {
    setState(() {
      _height = 425;
      _isLoading = true;
      if (_formKey.currentState.validate()) {
        _email = _emailTextController.text;
        _password = _passwordTextController.text;
        doFirebaseLogin(_email, _password);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  doFirebaseLogin(String email, String password) async {
    try {
      AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        print("Logged in with id ${result.user.email}");
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
          if (value.isEmpty && detectEmailOrPassword == 0) {
            widget.mListener._errorOccurred();
            return "Please enter a password ";
          } else if (!value.contains("@") && detectEmailOrPassword == 1) {
            widget.mListener._errorOccurred();
            return "Invalid Email address";
          } else if (value.length < 6 && detectEmailOrPassword == 0) {
            widget.mListener._errorOccurred();
            return "Password should be greater than 6 characters";
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
