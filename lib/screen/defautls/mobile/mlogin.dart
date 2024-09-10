import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/http_exception.dart';
import 'package:smerp/providers/auth.dart';
import 'package:smerp/screen/defautls/mobile/msignup.dart';
import 'package:smerp/utils/utils.dart';

class LoginM extends StatefulWidget {
  static const routeName='/mlogin';
  const LoginM({Key? key}) : super(key: key);

  @override
  State<LoginM> createState() => _LoginMState();
}

class _LoginMState extends State<LoginM> {


  final _formKey = GlobalKey<FormState>();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occerred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .logIn(_authData['email']!, _authData['password']!);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(_authData['email']!,);
    } on HttpException catch (error) {
      var errorMessage = 'Reset failed';
      if (error.toString().contains('MISSING_EMAIL')) {
        errorMessage = 'This email address is not in use.';
      }
      else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Wrong email address.Pls insert corret one or signup';
      }
      else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not reset password. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool isPassword = false;
  bool reset = false;
  String email = "", password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double fem = MediaQuery.of(context).size.width / 375;
    double ffem =fem*0.97;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width:width,
        height:height,
        decoration: BoxDecoration (
          color: const Color(0xffd7e5ff),
          borderRadius: BorderRadius.circular(40*fem),
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              offset: Offset(0*fem, 0*fem),
              blurRadius: 37.5*fem,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // autogroupcr8smVi (FCxmvXP5QswGDLZjG5cR8s)
                width: double.infinity,
                height: 398*fem,
                child: Stack(
                  children: [
                    Positioned(
                      // circle3sidebottem5mJ (9:8)
                      left: 235*fem,
                      top: -16*fem,
                      child: Align(
                        child: SizedBox(
                          width: 398*fem,
                          height: 398*fem,
                          child: Container(
                            decoration: BoxDecoration (
                              borderRadius: BorderRadius.circular(199*fem),
                              color: const Color(0xffb0cbff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circle2mid1YU (9:9)
                      left: -184*fem,
                      top: -412*fem,
                      child: Align(
                        child: SizedBox(
                          width: 700*fem,
                          height: 700*fem,
                          child: Container(
                            decoration: BoxDecoration (
                              borderRadius: BorderRadius.circular(350*fem),
                              color: const Color(0xd8367cfe),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circle1topUS4 (9:10)
                      left: -163*fem,
                      top: -292*fem,
                      child: Align(
                        child: SizedBox(
                          width: 398*fem,
                          height: 398*fem,
                          child: Container(
                            decoration: BoxDecoration (
                              borderRadius: BorderRadius.circular(199*fem),
                              color: const Color(0xff9bbefd),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // welcomebackKha (9:11)
                      left: 36*fem,
                      top: 132*fem,
                      child: Align(
                        child: SizedBox(
                          width: 216*fem,
                          height: 109*fem,
                          child: Text(
                            'Welcome\nBack',
                            style: SafeGoogleFont (
                              'Futura Hv BT',
                              fontSize: 46*ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575*ffem/fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(36*fem, 0, 36*fem,0),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // youremailGue (9:17)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                          padding: EdgeInsets.fromLTRB(30*fem, 19*fem, 30*fem, 18*fem),
                          width: double.infinity,
                          height: 70*fem,
                          decoration: BoxDecoration (
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20*fem),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                labelText: "Your Email",
                                border: InputBorder.none
                            ),
                            onChanged: (String value) {
                              _authData['email'] = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty ? 'Enter Email' : null;
                            }),
                          ),
                        ),
                        Container(
                          // password3Z2 (9:20)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                          padding: EdgeInsets.fromLTRB(30*fem, 19*fem, 30*fem, 18*fem),
                          width: double.infinity,
                          height: 70*fem,
                          decoration: BoxDecoration (
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20*fem),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: InputBorder.none,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  isPassword = !isPassword;
                                });
                              }, icon: isPassword?const Icon(Icons.visibility):const Icon(Icons.visibility_off)),
                            ),
                            obscureText: isPassword,
                            onChanged: (String value) {
                              _authData['password'] = value;
                            },
                            validator: ((value) {
                              if(!reset){
                                return value!.isEmpty ? 'Enter Email' : null;
                              }else {
                                return null;
                              }
                            }),
                          ),
                        ),
                        Container(
                          // autogroup4kv9pTJ (FCxn5gnUdMcMUkYcow4KV9)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 50*fem),
                          width: double.infinity,
                          height: 64*fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // signinWqv (9:12)
                                margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 115*fem, 0*fem),
                                child: Text(
                                  'Sign in',
                                  style: SafeGoogleFont (
                                    'Futura Hv BT',
                                    fontSize: 32*ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575*ffem/fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _submit,
                                child: Container(
                                  // arrowPep (9:29)
                                  padding: EdgeInsets.fromLTRB(21*fem, 24*fem, 19*fem, 24*fem),
                                  height: double.infinity,
                                  decoration: BoxDecoration (
                                    color: const Color(0xff367cfe),
                                    borderRadius: BorderRadius.circular(32*fem),
                                  ),
                                  child: Center(
                                    // arrowvector7Kv (9:26)
                                    child: SizedBox(
                                      width: 24*fem,
                                      height: 16*fem,
                                      child: Center(
                                        // arrowvector7Kv (9:26)
                                        child: _isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 4,):const Icon(Icons.east,color: Colors.white,),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 29*fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 121*fem,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // signupbottemPgk (9:13)
                                      left: 0*fem,
                                      top: 14*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 78*fem,
                                          height: 9*fem,
                                          child: Container(
                                            decoration: const BoxDecoration (
                                              color: Color(0x840a7de7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // signup65N (9:15)
                                      left: 5*fem,
                                      top: 0*fem,
                                      child: Align(
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).pushNamed(SignUpM.routeName);
                                          },
                                          child: SizedBox(
                                            width: 69*fem,
                                            height: 23*fem,
                                            child: Text(
                                              'Sign Up',
                                              style: SafeGoogleFont (
                                                'Futura Hv BT',
                                                fontSize: 18*ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575*ffem/fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                // autogroup6wpxYxx (FCxnQvjRBMj3Y7uV4d6WpX)
                                width: 159*fem,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // forgotbottemhax (9:14)
                                      left: 0*fem,
                                      top: 14*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 159*fem,
                                          height: 9*fem,
                                          child: Container(
                                            decoration: const BoxDecoration (
                                              color: Color(0x84ff0000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(

                                      left: 4*fem,
                                      top: 0*fem,
                                      child: Align(
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              reset = true;
                                            });
                                            _reset();
                                          },
                                          child: SizedBox(
                                            width: 154*fem,
                                            height: 23*fem,
                                            child: Text(
                                              'Forgot Passwords',
                                              style: SafeGoogleFont (
                                                'Futura Hv BT',
                                                fontSize: 18*ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575*ffem/fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
