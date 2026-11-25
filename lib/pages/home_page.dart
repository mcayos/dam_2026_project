import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_2026_project/constants.dart';
import 'package:dam_2026_project/pages/add_object.dart';
import 'package:dam_2026_project/pages/details_object.dart';
import 'package:dam_2026_project/services/auth_service.dart';
import 'package:dam_2026_project/services/fs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    AuthService().currentUser().then((currentU) {
      if (!mounted) return;
      setState(() {
        user = currentU;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(padding: EdgeInsetsGeometry.only(left: 8),child: Image.asset('assets/images/logo-usm2.png')),
        backgroundColor: cFondo1,
        title:  Center(
          child: Text('Objetos extraviados', style: TextStyle(color: cTextoClaro, fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      // Muestra la cuenta actual y la acción para cerrar sesión.
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? 'Usuario'),
                accountEmail: Text(user?.email ?? 'Sin correo'),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(color: cFondo1),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: cFondo1,
                      foregroundColor: cTextoClaro,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      } on FirebaseAuthException catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No se pudo cerrar sesión: ${error.message ?? error.code}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FsService().objetos(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var objetos = snapshot.data!.docs;
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              var objeto = objetos[index];
              return ListTile(
                // Abre los detalles usando el documento seleccionado.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailsObject(objeto: objeto),
                    ),
                  );
                },
                leading: Container(
                  width: 64,
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Image.network(
                    objeto['foto'],
                    fit: BoxFit.fill),
                ),
                title: Text(objeto['titulo']),
                subtitle: Text(
                  'Obj. de ${objeto['categoria']}${objeto['tipo'] == true ? ' ENCONTRADO' : ' Perdido'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: objeto['estado'] == true
                          ? Colors.green
                          : Colors.red,
                    ),  
                    SizedBox(width: 8),
                    Text(
                      objeto['estado'] == true ? 'Devuelto' : 'Vigente',
                    ),
                  ],
                ),
              );
            },
        );
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            MaterialPageRoute ruta = MaterialPageRoute(
              builder: (context) => AddObject());
            Navigator.push(context, ruta);
          },
          backgroundColor: cFondo1,
          child: Icon(MdiIcons.plus, color: cTextoClaro),
          ),
      );
  }
}

//To Do:
//Autenticacion con Google.
//Conexion al Storage de Firebase para fotos. (me pide suscripcion??)