import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 0, 26, 71),
            Color.fromARGB(255, 149, 208, 158)
          ], begin: Alignment.center, end: Alignment(2.0, 1.5)),
        ),
        child: Center(
          child: Container(
              height: 450,
              width: 400,
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
                          UserFormFields(
                              "Email",
                              Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 149, 208, 158),
                              ),
                              false,
                              1),
                          SizedBox(
                            height: 40,
                          ),
                          UserFormFields("Password", Icon(Icons.lock), true, 0)
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 60,
                            child: Card(
                              elevation: 10,
                              color: Color.fromARGB(255, 149, 208, 158),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                  child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20),
                              )),
                            ),
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
}

class UserFormFields extends StatefulWidget {
  final String text;
  final Icon icon;
  final bool isObscure;
  final int detect;
  UserFormFields(this.text, this.icon, this.isObscure, this.detect);

  @override
  _UserFormFieldsState createState() =>
      _UserFormFieldsState(this.text, this.icon, this.isObscure, this.detect);
}

class _UserFormFieldsState extends State<UserFormFields> {
  final String text;
  final Icon icon;
  bool isObscure;
  int detect;
  _UserFormFieldsState(this.text, this.icon, this.isObscure, this.detect);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: text,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color.fromARGB(255, 149, 208, 158))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color.fromARGB(255, 149, 208, 158))),
        prefixIcon: icon,
        suffixIcon: IconButton(
          icon: Icon(
            (detect == 0) ? Icons.remove_red_eye : null,
            color:
                (isObscure) ? Color.fromARGB(255, 149, 208, 158) : Colors.blue,
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
      ),
    );
  }
}
