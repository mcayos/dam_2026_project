import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_2026_project/constants.dart';
import 'package:dam_2026_project/pages/add_object.dart';
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
        backgroundColor: cFondo1,
        title:  Center(
          child: Text('Objetos extraviados', style: TextStyle(color: cTextoClaro, fontSize: 20, fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.logout),
            onPressed: () {}
      )]
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
                leading: Image.network(objeto['foto']),
                title: Text(objeto['titulo']),
                subtitle: Row(children: [Text('Objeto perdido en: '), Text(objeto['lugar'])],),
                trailing: Text(objeto['autor']),
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