import 'package:flutter/material.dart';
import 'package:the_wall_app/components/my_liste_title.dart';

class MyDrawer extends StatelessWidget {

  final void Function()? onTapProfile;
  final void Function()? onTapLogout;

  

  const MyDrawer({super.key, required this.onTapLogout, required this.onTapProfile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [// Header
          const DrawerHeader(child: Icon(Icons.person, color: Colors.white,
          size: 64,)),
          //home list tile
          MyListTitle(icon: Icons.home, text: 'H O M E',
          onTap: () => Navigator.pop(context),),
          
          //profile list tile
          MyListTitle(icon: Icons.person, text: 'P R O F I L E', onTap: onTapProfile),

          //loguot list tile
         ],),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTitle(icon: Icons.logout, 
            text: 'L O G O U T', onTap: onTapLogout),
          )
        ],
      ),
    );
  }
}