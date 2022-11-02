import 'dart:io';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/app/networking/user_api_service.dart';
import 'package:sailspad/resources/pages/tabbed/analytics_page.dart';

import '../../../app/controllers/controller.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/sailspad_icons.dart';
import 'create_card_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class TabsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  TabsPage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends NyState<TabsPage> {
  late List<Map<String, Object>> pages;
  Map _userDetails = {
    "firstName": "",
    "lastName": "",
    'profilePhoto': '',
    "jobTitle": '',
    "cardSlots": int,
    'availableCardSlots': int,
    'monthlySubscriptionStatus': "",
  };

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  void switchToEdit(String cardId) {
    setState(() {
      _selectedPageIndex = 3;
    });
  }

  @override
  init() async {
    pages = [
      {
        'page': HomePage(
          switchToEdit: switchToEdit,
        ),
        'title': 'Home'
      },
      {'page': AnalyticsPage(), 'title': 'Analytics'},
      {'page': ProfilePage(), 'title': 'Profile'},
      {'page': CreateCardPage(), 'title': 'CreateCard'},
    ];
    await loadUserDetails();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> loadUserDetails() async {
    final response = await api<UserApiService>(
      (request) => request.getuserDetails(),
      context: context,
    );
    if (response != null) {
      setState(() {
        _userDetails = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          shadowColor: Color.fromARGB(255, 182, 182, 182),
          backgroundColor: Color(0xFFD8E3E9),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Color(0xFF455154),
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 30, left: 24, right: 24),
            height: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //user details
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(54),
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              _userDetails['profilePhoto'].isNotEmpty
                                  ? NetworkImage(_userDetails['profilePhoto']!)
                                      as ImageProvider
                                  : AssetImage(
                                      'public/assets/images/nylo_logo.png'),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userDetails['firstName'] +
                                " " +
                                _userDetails['lastName'],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          Text(
                            _userDetails['jobTitle'],
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          Text(
                            _userDetails['availableCardSlots'].toString() +
                                "/" +
                                _userDetails['cardSlots'].toString(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await loadUserDetails();
                routeTo('/settings-page');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: FaIcon(
                  FontAwesomeIcons.gear,
                  color: Color(0xFF637579),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.2,
                // color: Color(0xFF455154),
              ),
            ),
            image: DecorationImage(
              image: AssetImage('public/assets/images/gradient_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: pages[_selectedPageIndex]['page'] as Widget,
        ),
        extendBody: true,
        bottomNavigationBar:
            _userDetails['monthlySubscriptionStatus'] == 'active' ||
                    _userDetails['monthlySubscriptionStatus'] == 'trialing' ||
                    _userDetails['monthlySubscriptionStatus'] == 'success'
                ? DotNavigationBar(
                    borderRadius: 50,
                    enableFloatingNavBar: true,
                    itemPadding: EdgeInsets.only(top: 2, bottom: 2),
                    marginR: EdgeInsets.only(
                        right: 25,
                        left: 25,
                        bottom: Platform.isAndroid ? 45 : 0),
                    paddingR: EdgeInsets.only(right: 25, left: 25, top: 15),
                    enablePaddingAnimation: false,
                    dotIndicatorColor: Colors.transparent,
                    backgroundColor: Color(0xFFE4E9EA).withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: -10,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ],
                    currentIndex: _selectedPageIndex,
                    onTap: _selectPage,
                    items: [
                      //Home
                      DotNavigationBarItem(
                        icon: Icon(SailspadIcons.home_icon),
                        selectedColor: Color(0xFF455154),
                        unselectedColor: Color(0xFF637579),
                      ),

                      //Analytics
                      DotNavigationBarItem(
                        icon: Icon(SailspadIcons.stats_icon),
                        selectedColor: Color(0xFF455154),
                        unselectedColor: Color(0xFF637579),
                      ),

                      //User Profile
                      DotNavigationBarItem(
                        icon: Icon(SailspadIcons.user_icon),
                        selectedColor: Color(0xFF455154),
                        unselectedColor: Color(0xFF637579),
                      ),

                      //Create New Card
                      DotNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.circlePlus),
                        selectedColor: Color(0xFF455154),
                        unselectedColor: Color(0xFF637579),
                      ),
                    ],
                  )
                : null,
      ),
    );
  }
}
