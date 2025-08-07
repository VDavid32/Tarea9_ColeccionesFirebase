import 'package:firebase_clase/ListaProductosTab.dart';
import 'package:firebase_clase/agregar_productos_tab.dart';
import 'package:firebase_clase/screen_ViewDays.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // use the returned token to send messages to users from your custom server
  String? token = await messaging.getToken();

  print(token);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeDias(),
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
