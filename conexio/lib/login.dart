import 'dart:convert';
import 'package:conexio/home.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

GlobalKey<FormState> validatekey = GlobalKey<FormState>();

class LoginPageState extends State<LoginPage> {
  bool obsure = true;
  int mobilenumber;
  String password;
  bool pageloading=false;
  // Future<void> loginFunction(int mbnum, String pass) async {
  //   Map<String, dynamic> logindata = {
  //     "token": "conexo",
  //     "mobile_no": mbnum,
  //     "password": pass
  //   };
  //   http
  //       .post(
  //           "http/:conexo.in/main/conexo-marketing/public/index.php/api/customer/memberlogin",
  //           body: jsonEncode(logindata))
  //       .then((http.Response response) {
  //         Map<String,dynamic>responsedata=jsonDecode(response.body);
  //          print(responsedata);

  //       });
  // }
  void initState(){
    super.initState();
    autoLogin();
  }
  void autoLogin()async{

    SharedPreferences pref=await SharedPreferences.getInstance();
    String name= pref.getString('name');
    String mobile= pref.getString('mobile_no');
    String areaallocated= pref.getString('area');
    String status= pref.getString('status');
    String memberid= pref.getString('member_id');
    
    if(name!=null && mobile!=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home(memberid)));
    }

    
  }

  Future<void> loginFunction() async {
    var logindata = {
      "token": "conexo",
      "mobile_no": mobilenumber,
      "password": password
    };
    http
        .post(
            "http://conexo.in/main/conexo-marketing/public/index.php/api/customer/memberlogin",
            body: json.encode(logindata),
             headers: {
        "Content-Type": "application/json"
      })
        .then((http.Response response)async {
          var data=json.decode(response.body);
         // print(data);
          if(data["message"]=="invalid_mobile_password"){

             showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Incorrect Credientials"),
              title: Text("Login Fail"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                   // authkey.currentState.reset();
                  },
                )
              ],
            );
          });
          setState(() {
           pageloading=false; 
          });
          }
          else{
            print(data);
            SharedPreferences pref =await SharedPreferences.getInstance();
            pref.setString('password', password);
            pref.setString('mobile_no', mobilenumber.toString());
            pref.setString('name', data["name"]);
            pref.setString('area', data["area"]);
            pref.setString('status',data["status"]);
            pref.setString('member_id',data["member_id"]);
           
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home(data["member_id"])));
            

          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return pageloading?Scaffold(body: Center(
      child: CircularProgressIndicator(),
    ),):Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 100.0,
          backgroundColor: Colors.white,
          expandedHeight: 80,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 8.0, bottom: 10.0),
              // centerTitle: true,
              title: Text(
                'Login',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              background: Container()),
        ),
        SliverFillRemaining(
          child: SingleChildScrollView(
              child: Form(
            key: validatekey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 112.0, bottom: 100),
                  child: Image.asset(
                    "assets/connected_logo_take2-12.png",
                    height: 100.0,
                  ),
                ),
                // Align(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 32.0, left: 12.0),
                //     child: Text(
                //       "Login",
                //       style: TextStyle(fontSize: 25),
                //     ),
                //   ),
                //   alignment: Alignment.centerLeft,
                // ),

                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 52.0, right: 52.0),
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
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color.fromRGBO(116, 49, 155, 20),
                      ),
                      fillColor: Color.fromRGBO(116, 49, 155, 20),
                      // icon: Icon(
                      //   Icons.phone,
                      //   color: Color.fromRGBO(116, 49, 155, 20),
                      // ),
                      hintText: "Mobile No",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 52.0, right: 52.0),
                  child: TextFormField(
                    obscureText: obsure,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Password must contain atleast 6 char";
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      password = value;
                      print(password);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Color.fromRGBO(116, 49, 155, 20),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (obsure) {
                            setState(() {
                              print(obsure);
                              obsure = false;
                            });
                          } else {
                            setState(() {
                              print(obsure);
                              obsure = true;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.visibility,
                        ),
                      ),
                      fillColor: Color.fromRGBO(116, 49, 155, 20),
                      // icon: Icon(
                      //   Icons.vpn_key,
                      //   color: Color.fromRGBO(116, 49, 155, 20),
                      // ),
                      hintText: "password",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0, left: 52.0, right: 52.0),
                  child: RaisedButton(
                    onPressed: () {
                      validatekey.currentState.validate();
                      validatekey.currentState.save();
                      // loginFunction(mobilenumber,password);
                      setState(() {
                       pageloading=true; 
                      });
                      loginFunction();
                    },
                    elevation: 5.0,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.26,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(116, 49, 155, 20),
                          borderRadius:
                              BorderRadius.all(Radius.circular(80.0))),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: const Text('Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ],
            ),
          )),
        )
      ],
    ));
  }
}
