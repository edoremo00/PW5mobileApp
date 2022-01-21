// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/Services/Userservice.dart';
import 'package:getfitappmobile/core.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/view/home_page.dart';
import 'package:getfitappmobile/view/user_profile_page.dart';
import 'package:getfitappmobile/view/workouts_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;
  UserModel passtohomepage = UserModel();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getlogged().then((value) {
      if (value != null) {
        username = value;
        UserService().Getsingleuser(username: value).catchError((e) {
          print(e);
        }).then((value) {
          if (value != null) {
            setState(() {
              passtohomepage = value;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Workouts(
        model: passtohomepage,
      ),
      HomePage(
        model: passtohomepage,
        username: username,
      ),
      UserProfile(
        user: passtohomepage,
      )
    ];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kThirdColor,
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: kSecondColor,
          elevation: 12,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Text(
                "Workouts",
                style:
                    TextStyle(color: kFirstColor, fontWeight: FontWeight.w900),
              ),
              icon: Text(
                "Workouts",
                style:
                    TextStyle(color: kFirstColor, fontWeight: FontWeight.w400),
              ),
              label: 'workouts',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded), label: 'home'),
            BottomNavigationBarItem(
                activeIcon: Text(
                  "Profile",
                  style: TextStyle(
                      color: kFirstColor, fontWeight: FontWeight.w900),
                ),
                icon: Text(
                  "Profile",
                  style: TextStyle(
                      color: kFirstColor, fontWeight: FontWeight.w400),
                ),
                label: 'profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Future<String?> getlogged() async {
    String? usercredentials =
        await Tokenstorage.retrieveusercredentials('usercredentials');

    if (usercredentials != null) {
      String saveduser = Loginmodel.fromJson(usercredentials).Username;
      return saveduser;
    } else {
      String? username =
          await Tokenstorage.retrieveusercredentials('usernamecredential');
      return username;
    }
  }
}
