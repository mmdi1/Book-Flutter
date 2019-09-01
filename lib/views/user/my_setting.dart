import 'package:flutter/material.dart';

class MySetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("JoucksHua",
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("527201001@qq.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "http://7xqekd.com1.z0.glb.clouddn.com/imgs/24910959%20%281%29.jpeg"),
            ),
            decoration: BoxDecoration(
              // color: Colors.yellow[400],
              image: DecorationImage(
                image: NetworkImage(
                    'http://7xqekd.com1.z0.glb.clouddn.com/imgs/781566043546.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.5), BlendMode.hardLight),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Messages',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.message, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text(
              'Favorite',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.favorite, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text(
              'Settings',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.settings, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
