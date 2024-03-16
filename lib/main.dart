import 'package:database_example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner:false,
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      useMaterial3: false,
      cardTheme: CardTheme().copyWith(color:Colors.indigo.shade50),),
    home: const HomeScreen(),
  )));

}



