import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_clase/auth/loginPage.dart';
import 'package:firebase_clase/main.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeDias extends StatelessWidget {
  const HomeDias({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final userEmail = storage.read('userEmail') ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Dias de la semana',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Bienvenido $userEmail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Lunes'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Lunes'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Martes'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Martes'),
                ),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Miercoles'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Miercoles'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Jueves'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Jueves'),
                ),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Viernes'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Viernes'),
                ),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Sabado'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Sabado'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(dia: 'Domingo'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Text('Domingo'),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    final storage = GetStorage();
                    storage.erase();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    side: MaterialStatePropertyAll(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
