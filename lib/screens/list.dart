import 'dart:convert';
import 'package:app_ri/models/bar.dart';
import 'package:app_ri/models/myFileStorage.dart';
import 'package:app_ri/screens/listData.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';


class ListScreen extends StatefulWidget{
  const ListScreen({ super.key });

  @override
  _ListScreen createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
   
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
         child: ListView(
          children: [
            // MyContainer(link: ListDataScreen(name: 'lugares', text: 'Lugares',), text: "Lugares", icon: Icons.place),
            // MyContainer(link: ListDataScreen(name: 'pueblos', text: 'Pueblos',), text: "Pueblos", icon: Icons.location_city),
            // MyContainer(link: ListDataScreen(name: 'casasRurales', text: 'Casas Rurales',), text: "Casas Rurales", icon: Icons.villa_rounded),
            // MyContainer(link: ListDataScreen(name: 'museos', text: 'Museos'), text: 'Museos', icon: Icons.museum_rounded),
            
            
            
            // Favoritos
            Padding(padding: EdgeInsets.all(60)),
            MyContainer(link: ListDataScreen(name: 'Bares'), text: 'Bares', icon: Icons.restaurant_menu),
            Padding(padding: EdgeInsets.all(60)),
            MyContainer(link: ListDataScreen(name: 'Salones'), text: 'Salones', icon: Icons.gamepad),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () async {
                var json = new Bar(id: 1, nombre: '', ubic: '').toJson().toString();
                FileStorage.writeCounter('$json', 'data.json');
              }, 
              style: ElevatedButton.styleFrom(
                primary: AppTheme.primary, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Copia de Seguridad',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              
            )
          ],
         ),
      ),
    );
  }
}



// Clase para generar un ListTile con el link a la Screen, texto e icono
class MyContainer extends StatelessWidget {
  final Widget link;
  final String text;
  final IconData icon;
  const MyContainer({
    Key? key, required this.link, required this.text, required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.001),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(194, 194, 194, 1),
            spreadRadius: 1,
            blurRadius: 2
          )
        ]
      ),
      child: ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: AppTheme.primary,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      
      trailing: Icon(Icons.navigate_next,size: 30,),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => link
            )
        )
      }

    ),
    );
  }
}
