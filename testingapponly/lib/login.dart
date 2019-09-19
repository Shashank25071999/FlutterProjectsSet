import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

GlobalKey<FormState> validatekey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginApp> {
  int mobilenumber;
  String password;
  // f45d27
  // f5851f

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
             // color: Color.fromRGBO(116, 49, 155, 14),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.9,
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: <Color>[
                  //     Color(0xFF0D47A1),
                  //     Color(0xFF1976D2),
                  //     Color(0xFF42A5F5),
                  //   ],
                  // ),
                  color: Color.fromRGBO(116, 40, 155, 80),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child:Image.asset("assets/connected_logo_take2-12.png",height:200.0)
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
                key: validatekey,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 62),
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4),
                          // decoration: BoxDecoration(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(50)),
                          //     color: Colors.white,
                          //     boxShadow: [
                          //       BoxShadow(color: Colors.black12, blurRadius: 5)
                          //     ]),
                          child: TextFormField(
                          
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regex = new RegExp(patttern);
                              if (value.length == 0) {
                                return 'Please enter mobile number';
                              } else if (!regex.hasMatch(value)) {
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              mobilenumber = int.parse(value);
                              print(mobilenumber);
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              hintText: 'Mobile Number',
                            ),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 70,
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(50)),
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(color: Colors.black12, blurRadius: 5)
                        //     ]),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.grey,
                            ),
                            hintText: 'Password',
                          ),
                          onSaved: (value) {
                            password = value;
                            print(password);
                          },
                          validator: (value) {
                            if (value.length < 6) {
                              return "Password must be greater than 6 char";
                            } else
                              return null;
                          },
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        onPressed: () {
                          validatekey.currentState.validate();
                          validatekey.currentState.save();
                        },
                        elevation: 20.0,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: const BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: <Color>[
                              //     Color(0xFF0D47A1),
                              //     Color(0xFF1976D2),
                              //     Color(0xFF42A5F5),
                              //   ],
                              // ),
                              color: Color.fromRGBO(116, 49, 155, 80),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0))),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: const Text('Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
