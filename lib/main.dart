import 'package:firebase_clase/ListaProductosTab.dart';
import 'package:firebase_clase/agregar_productos_tab.dart';
import 'package:firebase_clase/auth/loginPage.dart';
import 'package:firebase_clase/screen_ViewDays.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // use the returned token to send messages to users from your custom server
  String? token = await messaging.getToken();

  print(token);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final storage = GetStorage();
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final hayData = storage.read('logueado') ?? false;
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: hayData ? 
      HomeDias()
      : LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String dia;
  const HomePage({super.key, required this.dia});
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestión Productos'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Agregar Productos'),
              Tab(text: 'Listado de Productos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AgregarProductosTab(dia: dia), 
            ListaProductosTab(dia: dia,)
            ],
        ),
      ),
    );
  }
}
