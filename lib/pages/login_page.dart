import 'package:dam_2026_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String mensajeError = "";
  bool hayError = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cFondo1,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          width: 320,
          height: 640,
          decoration: BoxDecoration(
            color: cFondo2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo-usm.png'),
                SizedBox(height: 16),
                Text('Bienvenido/a!', style: TextStyle(fontSize: 20)),
                SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        
                        hayError = false;
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailCtrl.text.trim(),
                          password: passwordCtrl.text.trim(),
                        );
                      } on FirebaseAuthException catch (ex) {
                        // print(ex.code);
                        hayError = true;
                        switch (ex.code) {
                          case 'channel-error':
                            mensajeError = "Ingrese sus credenciales";
                            break;
                          case 'invalid-email':
                            mensajeError = "Email no válido";
                            break;
                          case 'invalid-credential':
                            mensajeError = "Credenciales no válidas";
                            break;
                          case 'user-disabled':
                            mensajeError = "Cuenta desactivada";
                            break;
                          default:
                            mensajeError = "No se pudo iniciar sesión";
                        }
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cFondo1,
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: cTextoClaro),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                hayError
                    ? Container(
                        height: 45,
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(MdiIcons.alert, color: cPrimario),
                            SizedBox(width: 10),
                            Text(
                              mensajeError,
                              style: TextStyle(color: cPrimario),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}