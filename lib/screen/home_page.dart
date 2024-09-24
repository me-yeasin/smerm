import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smerp/lc/lc_entey.dart';
import 'package:smerp/pages/bank-sell/bank_sell.dart';
import 'package:smerp/pages/booked-chaasis-list/booked_chaasis_list.dart';
import 'package:smerp/pages/customer-sell/customer_sell.dart';
import 'package:smerp/pages/landing-page/landing_page.dart';
import 'package:smerp/pages/lc-info/lc_info.dart';
import 'package:smerp/pages/report/report.dart';
import 'package:smerp/pages/unsold-item-list/unsold_item_list.dart';
import 'package:smerp/pages/vat-not-given-list/vat_not_given_list.dart';
import 'package:smerp/providers/auth.dart';
import 'package:smerp/providers/design.dart';
import 'package:smerp/utils/app_colors.dart';

import '../providers/contents.dart';
import 'defautls/dlogin.dart';
import 'defautls/mobile/mlogin.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHomePage = true;
  int selectedIndex = 0;

  List homePageList = [
    LcInfoPage(),
    const BankSellPage(),
    const CustomerSellPage(),
    const UnsoldItemListPage(),
    const VatNotGivenListPage(),
    const BookedChaasisListPage(),
    const ReportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Auth a = Provider.of<Auth>(context);
    a.isAuth ? Provider.of<Contents>(context).fetchAndPrintPosts() : null;
    const isAuth = true;
    Design design = Provider.of<Design>(context);
    double width = MediaQuery.of(context).size.width;
    PreferredSizeWidget appBar = AppBar(
      toolbarHeight: 90.0,
      backgroundColor: colorP500,
      leading: const Padding(
        padding: EdgeInsets.all(
          8.0,
        ),
        child: CircleAvatar(
          backgroundColor: colorPrimaryS300,
        ),
      ),
      title: const Text(
        "Auto-Mobile Manager",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorPrimaryS300,
        ),
      ),
      titleSpacing: 10.0,
      actions: [
        const CircleAvatar(
          backgroundColor: Colors.greenAccent,
          radius: 15.0,
        ),
        const SizedBox(
          width: 15.0,
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/settiing.svg",
            height: 27.0,
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/log-out.svg",
            height: 23.0,
          ),
        ),
      ],
    );
    design.setAppBarHeight = appBar.preferredSize.height;
    return isAuth //! Change it to a.isAuth
        ? Scaffold(
            appBar: appBar,
            body: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login-bg-two.png"),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
              child: design.getIsHomePage
                  ? LandingPage()
                  : homePageList[selectedIndex],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  LcEntry.routeName,
                );
              },
              backgroundColor: colorPrimaryS300,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        : (width < 920 ? const LoginM() : const LogInPage());
  }
}




// Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                       width: 200,
//                       child: MaterialButton(
//                         onPressed: () async {
//                           width < 100
//                               ? Navigator.of(context)
//                                   .pushNamed(LcReportScreenM.routeName)
//                               : Navigator.of(context)
//                                   .pushNamed(LcReportScreen.routeName);
//                         },
//                         color: Theme.of(context).primaryColorDark,
//                         textColor: Colors.white,
//                         child: const Text(
//                           "LC Info",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         height: 50,
//                         width: 200,
//                         child: MaterialButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(QuotationScreen.routeName);
//                           },
//                           color: Theme.of(context).primaryColorDark,
//                           textColor: Colors.white,
//                           child: const Text(
//                             "Bank Sale",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                         )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                       height: 50,
//                       width: 200,
//                       child: MaterialButton(
//                         onPressed: () async {
//                           Navigator.of(context)
//                               .pushNamed(CustomerSealScreen.routeName);
//                         },
//                         color: Theme.of(context).primaryColorDark,
//                         textColor: Colors.white,
//                         child: const Text(
//                           "Customer Sale",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         height: 50,
//                         width: 200,
//                         child: MaterialButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(UnsoldScreen.routeName);
//                           },
//                           color: Theme.of(context).primaryColorDark,
//                           textColor: Colors.white,
//                           child: const Text(
//                             "Unsold List",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                         )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         height: 50,
//                         width: 200,
//                         child: MaterialButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(NotGivenVatScreen.routeName);
//                           },
//                           color: Theme.of(context).primaryColorDark,
//                           textColor: Colors.white,
//                           child: const Text(
//                             "VAT List",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                         )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         height: 50,
//                         width: 200,
//                         child: MaterialButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(BookedScreen.routeName);
//                           },
//                           color: Theme.of(context).primaryColorDark,
//                           textColor: Colors.white,
//                           child: const Text(
//                             "Booked List",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                         )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                       height: 50,
//                       width: 200,
//                       child: MaterialButton(
//                         onPressed: () async {
//                           Navigator.of(context)
//                               .pushNamed(ReportSelectionPage.routeName);
//                         },
//                         color: Theme.of(context).primaryColorDark,
//                         textColor: Colors.white,
//                         child: const Text(
//                           "Report",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),