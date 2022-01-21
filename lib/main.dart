import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/routes/app_pages.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';

String? savedcredentials = "";
String? usernamecredential = "";
bool isbanned = false;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
  WidgetsFlutterBinding.ensureInitialized();
  savedcredentials =
      await Tokenstorage.retrieveusercredentials('usercredentials');
  usernamecredential =
      await Tokenstorage.retrieveusercredentials('usernamecredential');
  if (savedcredentials != null) {
    bool loginresult =
        await Authservice().login(Loginmodel.fromJson(savedcredentials!));
    if (loginresult) {
      bool checkbanned = await checkadmin();
      checkbanned ? isbanned = checkbanned : checkbanned = checkbanned;
    }
  }

  runApp(MyApp());
}

Future<bool> checkadmin() async {
  Map<String, dynamic>? decodetoken =
      await Tokenstorage.Decodejwttoken('token');
  if (decodetoken != null) {
    String role = decodetoken[
            "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]
        .toString();
    return ((role == 'Admin' ||
            role == '[SuperAdmin, Admin, Basic, Ban]' ||
            role == '[Basic, Ban]')
        ? true
        : false);
  }
  return false;
}

class MyApp extends StatefulWidget {
  final Authservice auth = Authservice();
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    //final isbackground = state == AppLifecycleState.paused;
    final isclosed = state == AppLifecycleState.detached;
    if (isclosed && savedcredentials == null) {
      String? username =
          await Tokenstorage.retrieveusercredentials('usernamecredential');
      if (username != null) {
        bool? logoutresult = await widget.auth.logout(username: username);
        if (logoutresult) {
          await Tokenstorage.removetokenfromstorage('token');
          await Tokenstorage.removeuserfromstorage('usernamecredential');
        }
      }
    }
    print(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "GetFit",
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark().copyWith(
        primaryColor: kFirstColor,
        dialogBackgroundColor: kThirdColor,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: kFirstColor),
        hintColor: Colors.white,
        textTheme: const TextTheme(subtitle1: TextStyle(color: Colors.white)),
      ),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
      transitionDuration: const Duration(milliseconds: 230),
      initialRoute: savedcredentials != null
          ? isbanned
              ? Routes.ADMINERRORPAGE
              : AppPages.INITIALIFSAVEDCREDENTIALS
          : AppPages.INITIAL,
      // initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
