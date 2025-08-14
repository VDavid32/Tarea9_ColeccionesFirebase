import 'package:firebase_clase/screen_ViewDays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = GetStorage();

  bool _obscurePassword = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        final user = userCredential.user;
        if (user != null) {
          storage.write('logueado', true);
          storage.write('userEmail', user.email ?? '');
          Get.offAll(HomeDias(), transition: Transition.rightToLeft);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuario no registrado';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta';
            break;
          case 'invalid-email':
            errorMessage = 'Correo inválido';
            break;
          default:
            errorMessage =
                'No se pudo iniciar sesión, por favor intente de nuevo';
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Ocurrió un error inesperado',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFF9FBE7),
              Color(0xFFF0EDD4),
              Color(0xFFECCDB4),
              Color(0xFFFEA1A1),
              Color(0xFFD14D72),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Iniciar Sesión',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 48,
                              color: const Color(0xFF89375F),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Bienvenido!',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF89375F)),
                          ),
                          SizedBox(height: 30),

                          // Email TextField
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFEA1A1),
                                hintText: 'Correo Electrónico',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xFFF0EDD4),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu correo';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Correo no válido';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),

                          // Password TextField
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFEA1A1),
                                hintText: 'Contraseña',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFFF0EDD4),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFFF0EDD4),
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF0EDD4),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 20),

                          // Botón de ingresar
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF89375F),
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFF0EDD4),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Ingresar',
                                        style: TextStyle(
                                          color: Color(0xFFF0EDD4),
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Texto de registro
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿Aun no tienes una cuenta?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF89375F),
                                ),
                              ),
                              Text(
                                '  Regístrese Aquí!',
                                style: TextStyle(
                                  color: Color(0xFFF0EDD4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
