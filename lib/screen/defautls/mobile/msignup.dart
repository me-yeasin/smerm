import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/http_exception.dart';
import 'package:smerp/providers/auth.dart';
import 'package:smerp/screen/defautls/mobile/mlogin.dart';
import 'package:smerp/utils/utils.dart';

class SignUpM extends StatefulWidget {
  static const routeName='/msignup';
  const SignUpM({Key? key}) : super(key: key);

  @override
  State<SignUpM> createState() => _SignUpMState();
}

class _SignUpMState extends State<SignUpM> {
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
          .signUp(_authData['email']!, _authData['password']!).whenComplete(() => Navigator.of(context).pushNamed(LoginM.routeName));
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
  bool isPassword = false;
  bool isConfirmPassword = false;


  TextEditingController nameController = TextEditingController();
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
        // signuppageeuW (9:30)
        width: width,
        height: height,
        decoration: BoxDecoration (
          color: Color(0xffd7e5ff),
          borderRadius: BorderRadius.circular(40*fem),
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0*fem, 0*fem),
              blurRadius: 37.5*fem,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: width,
                height:316*fem,
                child: Stack(
                  children: [
                    Positioned(
                        left: -284*fem,
                        top: -414*fem,
                        child: Container(
                          width: 700*fem,
                          height:700*fem,
                          decoration: BoxDecoration (
                            color: Color(0xd8367cfe),
                            borderRadius: BorderRadius.circular(350*fem),
                          ),
                        )),
                    Positioned(
                      left: 36*fem,
                      top: 132*fem,
                      child: Container(
                        constraints: BoxConstraints (
                          maxWidth: 175*fem,
                        ),
                        child: Text(
                          'Create\nAccount',
                          style: SafeGoogleFont (
                            'Futura Hv BT',
                            fontSize: 46*ffem,
                            fontWeight: FontWeight.w900,
                            height: 1.2575*ffem/fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(36*fem, 30*fem, 0*fem, 0*fem),
                  width: double.infinity,
                  height: 570*fem,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // namevtx (9:40)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 36*fem, 20*fem),
                          padding: EdgeInsets.fromLTRB(30*fem, 19*fem, 30*fem, 18*fem),
                          width: 303*fem,
                          height: 70*fem,
                          decoration: BoxDecoration (
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20*fem),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                labelText: "Your Email",
                                border: InputBorder.none
                            ),
                            onChanged: (String value) {
                              _authData['email'] = value!;
                            },
                            validator: ((value) {
                              return value!.isEmpty ? 'Enter Email' : null;
                            }),
                          ),
                        ),
                        Container(
                          // youremailayW (9:37)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 36*fem, 20*fem),
                          padding: EdgeInsets.fromLTRB(30*fem, 19*fem, 30*fem, 18*fem),
                          width: 303*fem,
                          height: 70*fem,
                          decoration: BoxDecoration (
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20*fem),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: InputBorder.none,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  isPassword = !isPassword;
                                });
                              }, icon: isPassword?Icon(Icons.visibility):Icon(Icons.visibility_off)),
                            ),
                            obscureText: isPassword,
                            onChanged: (String value) {
                              _authData['password'] = value!;
                            },
                            validator: ((value) {
                              return value!.isEmpty ? 'Enter Password' : null;
                            }),
                          ),
                        ),
                        Container(
                          // password2ac (9:43)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 36*fem, 30*fem),
                          padding: EdgeInsets.fromLTRB(30*fem, 19*fem, 30*fem, 18*fem),
                          width: 303*fem,
                          height: 70*fem,
                          decoration: BoxDecoration (
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20*fem),
                          ),
                          child:TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              border: InputBorder.none,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  isConfirmPassword = !isConfirmPassword;
                                });
                              }, icon: isConfirmPassword?Icon(Icons.visibility):Icon(Icons.visibility_off)),
                            ),
                            obscureText: isConfirmPassword,
                            validator: (value) {
                              if (value.toString() != passwordController.text.toString()) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          // autogroupgtvdS8Y (FCxokdzvwVix7JrPPHGtVd)
                          width: double.infinity,
                          height: 259*fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // signupYhN (9:34)
                                margin: EdgeInsets.fromLTRB(0*fem, 13*fem, 8*fem, 0*fem),
                                child: Text(
                                  'Sign Up',
                                  style: SafeGoogleFont (
                                    'Futura Hv BT',
                                    fontSize: 32*ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // autogroupfbdqz3a (FCxow8hShKExsKxVhqfBDq)
                                  width: 459*fem,
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // circlebottemKLk (9:31)
                                        left: 0*fem,
                                        top: 13*fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 459*fem,
                                            height: 398*fem,
                                            child: Image.asset(
                                              'assets/cover-page/images/circle-bottem.png',
                                              width: 459*fem,
                                              height: 398*fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // signinbottemzhn (9:35)
                                        left: 107*fem,
                                        top: 188*fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 78*fem,
                                            height: 9*fem,
                                            child: Container(
                                              decoration: BoxDecoration (
                                                color: Color(0x840a7de7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // signinh6Q (9:36)
                                        left: 116*fem,
                                        top: 174*fem,
                                        child: Align(
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).pushNamed(LoginM.routeName);
                                            },
                                            child: SizedBox(
                                              width: 56*fem,
                                              height: 23*fem,
                                              child: Text(
                                                'Sign In',
                                                style: SafeGoogleFont (
                                                  'Futura Hv BT',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.2575*ffem/fem,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // arrow9DJ (9:52)
                                        left: 121*fem,
                                        top: 0*fem,
                                        child: GestureDetector(
                                          onTap: _submit,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(21*fem, 24*fem, 19*fem, 24*fem),
                                            width: 64*fem,
                                            height: 64*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff367cfe),
                                              borderRadius: BorderRadius.circular(32*fem),
                                            ),
                                            child: Center(
                                              // arrowvector1FW (9:49)
                                              child: SizedBox(
                                                width: 24*fem,
                                                height: 16*fem,
                                                child: _isLoading?CircularProgressIndicator(color: Colors.white,strokeWidth: 4,):Image.asset(
                                                  'assets/cover-page/images/arrow-vector-dX6.png',
                                                  width: 24*fem,
                                                  height: 16*fem,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
