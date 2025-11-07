import 'package:flutter/material.dart';
import 'atelier1.dart'; // Importe ProfilePageM3
import 'atelier2.dart'; // Importe ProductListPageM3 (Contient la liste des produits)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Material 3',
      // Utilisation du thème Material 3
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false, 
      
      // DÉFINITION DES ROUTES
      initialRoute: '/profile', // Démarrage sur la page de profil
      routes: {
        '/profile': (context) => const ProfilePageM3(),
        // Pointage clair vers la page de liste des produits dans atelier2.dart
        '/products': (context) => const ProductListPageM3(),
      },
    );
  }
}
