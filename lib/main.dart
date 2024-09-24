import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/lc/lc_entey.dart';
import 'package:smerp/lc/lc_report_screen.dart';
import 'package:smerp/providers/auth.dart';
import 'package:smerp/providers/contents.dart';
import 'package:smerp/providers/design.dart';
import 'package:smerp/screen/defautls/dlogin.dart';
import 'package:smerp/screen/defautls/mobile/mlogin.dart';
import 'package:smerp/screen/defautls/mobile/msignup.dart';
import 'package:smerp/screen/report/bank_report.dart';
import 'package:smerp/screen/report/bill_report.dart';
import 'package:smerp/screen/report/challan_report.dart';
import 'package:smerp/screen/report/quotation_report.dart';
import 'package:smerp/screen/report/report_customer.dart';
import 'package:smerp/screen/report/sale_customer_report.dart';
import 'package:smerp/screen/reportSelection.dart';
import 'package:smerp/screen/verticals/bank_sale_screen.dart';
import 'package:smerp/screen/verticals/booked.dart';
import 'package:smerp/screen/verticals/customer_sale_screen.dart';
import 'package:smerp/screen/verticals/unsold.dart';
import 'package:smerp/screen/verticals/vat.dart';
import 'package:window_manager/window_manager.dart';

import 'lc/chasis_entry.dart';
import 'lc/mobile/mlc_report_screen.dart';
import 'screen/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WindowManager.instance.setMinimumSize(const Size(1280, 650));
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Contents(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
          child: const MyApp(),
        ),
        ChangeNotifierProvider(create: (ctx) => Design()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Automobile Manager',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            primaryColor: Colors.purpleAccent,
          ),
          // initialRoute: auth.isAuth?SignUp.routeName:HomePage.routeName,
          // home: auth.isAuth?HomePage():(width<920?LoginM():LogInPage()),
          // home: const HomePage(),
          // home: LcReportScreenM(),
          initialRoute: HomePage.routeName,
          routes: {
            SignUpM.routeName: (context) => const SignUpM(),
            LoginM.routeName: (context) => const LoginM(),
            LogInPage.routeName: (context) => const LogInPage(),
            HomePage.routeName: (context) => const HomePage(),
            LcReportScreenM.routeName: (context) => const LcReportScreenM(),
            ChasisEntry.routeName: (context) => const ChasisEntry(),
            LcEntry.routeName: (context) => const LcEntry(),
            LcReportScreen.routeName: (context) => const LcReportScreen(),
            UnsoldScreen.routeName: (context) => const UnsoldScreen(),
            BookedScreen.routeName: (context) => const BookedScreen(),
            NotGivenVatScreen.routeName: (context) => const NotGivenVatScreen(),
            QuotationScreen.routeName: (context) => const QuotationScreen(),
            CustomerReport.routeName: (context) => const CustomerReport(),
            BillReport.routeName: (context) => const BillReport(),
            BankReport.routeName: (context) => const BankReport(),
            ChallanReport.routeName: (context) => const ChallanReport(),
            ReportSelectionPage.routeName: (context) =>
                const ReportSelectionPage(),
            QuotationReport.routeName: (context) => const QuotationReport(),
            CustomerSealScreen.routeName: (context) =>
                const CustomerSealScreen(),
            SaleCustomerReport.routeName: (context) =>
                const SaleCustomerReport(),
          },
        ),
      ),
    );
  }
}
