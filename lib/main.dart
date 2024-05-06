import 'package:invest_mobile/providers/details_pack.dart';
import 'package:invest_mobile/providers/login_info.dart';
import 'package:invest_mobile/providers/messous_provider.dart';
import 'package:invest_mobile/providers/pack_provider.dart';
import 'package:invest_mobile/providers/user_provider.dart';
import 'package:invest_mobile/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginInfo()),
    ChangeNotifierProvider(create: ((context) => UserProvider())),
    ChangeNotifierProvider(create: ((context) => PackProvider())),
    ChangeNotifierProvider(create: ((context) => DetailsPackProv())),
    ChangeNotifierProvider(create: ((context) => MesSousProvider()))
  ], builder: (context, child) => const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // HttpOverrides.global = MyHttpOverrides();
    super.initState();
    initialisation();
  }

  void initialisation() async {
    await context.read<LoginInfo>().loadState();
    // ignore: use_build_context_synchronously
    if (context.read<LoginInfo>().isOnline) {
      // ignore: use_build_context_synchronously
      await context.read<UserProvider>().userInfo();
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginInfo>(builder: (context, value, child) {
      // print(value.isOnline);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.black, fontFamily: 'dmSans'),
        initialRoute: value.isOnline == true ? MyRoute.homePage : MyRoute.begin,
        onGenerateRoute: MyRoute.generateRoute,
      );
    });
  }
}
