import 'package:flutter/material.dart';

enum AuthPage { SignIn, LogIn }

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthState();
  }
}


class AuthState extends State<Auth> {
  AuthPage authPage = AuthPage.LogIn;
  String password;
  String confirmpassword;
  String email;
  final GlobalKey<FormState> formstate=GlobalKey<FormState>();
  Map product={
    'password': '',
    'email':'',
    'confirmpassword':''

  };


  TextEditingController passwordcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Auth'),
        ),
        body: Container(
          child: Form(key: formstate,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  validator: (String value) {
                    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value)) {
                      return "email format is not correct";
                    }
                  },
                  decoration:
                      InputDecoration(labelText: 'Email', hintText: "email"),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String value) {
                    email=value;
                  },
                ),
                TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      labelText: 'Password', hintText: "Password"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value){
                    if(value.length<=5||value.isEmpty){
                      return 'Paswword is required ';
                    }
                  },
                  onSaved: (String value) {
                    password=value;
                  },
                ),
                authPage == AuthPage.SignIn
                    ? TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: "Confirm Password"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value){
                          if(passwordcontroller.text!=value){
                            return 'password does not match';
                          }
                        },
                        onSaved: (String value) {
                          confirmpassword=value;
                        },
                      )
                    : Container(),
                RaisedButton(
                  child: Text(authPage == AuthPage.LogIn ? 'LogIn' : 'SignUp'),
                  onPressed: () {
                    setState(() {
                      authPage == AuthPage.LogIn
                          ? authPage = AuthPage.SignIn
                          : authPage = AuthPage.LogIn;
                    });
                  },
                ),
                RaisedButton(child: Text("Enter"),onPressed: (){
                  formstate.currentState.save();
                  formstate.currentState.validate();
                  setState(() {
                    product['email']=email;
                    product['password']=password;
                    product['confirmpassword']=confirmpassword;
                    print(product['email']);
                    print(product['password']);
                    print(product['confirmpassword']);
                  });
                },)
              ],
            ),
          ),
        ));
  }
}
