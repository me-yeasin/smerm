import 'package:flutter/material.dart';
import '../utils/utils.dart';

void SorryDialog(context,double fem,double ffem){
  showDialog(context: context, builder: (BuildContext){
    return Dialog(
      child: Container(
        padding: EdgeInsets.fromLTRB(203*fem, 150*fem, 203*fem, 64*fem),
        width: 784*fem,
        height: 599*fem,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // frame4id (112:33003)
              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 25.88*fem),
              width: 169*fem,
              height: 108.12*fem,
              child: Image.asset(
                'assets/nd-version/images/cross-svgrepo-com-3-1-jpm.png',
                width: 169*fem,
                height: 108.12*fem,
                color: Colors.red,
              ),
            ),
            Container(
              // thankyouxZ7 (112:33002)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 25*fem),
              child: Text(
                'Sorry Wrong Credentials',
                style: SafeGoogleFont (
                  'Inter',
                  fontSize: 30*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.1*ffem/fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Container(
                // frame427321306tBs (112:33005)
                margin: EdgeInsets.fromLTRB(23*fem, 0*fem, 23*fem, 0*fem),
                width: double.infinity,
                height: 80*fem,
                decoration: BoxDecoration (
                  gradient: LinearGradient (
                    begin: Alignment(0, -1),
                    end: Alignment(0, 1),
                    colors: <Color>[Color(0xff1899ff), Color(0xad1899ff)],
                    stops: <double>[0, 1],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Got It',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Inter',
                      fontSize: 50*ffem,
                      fontWeight: FontWeight.w500,
                      height: 1*ffem/fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}