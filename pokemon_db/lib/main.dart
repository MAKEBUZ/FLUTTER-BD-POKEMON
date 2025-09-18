import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/home_view.dart';
import 'models/team_pokemon_model.dart';
import 'services/team_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adaptadores de Hive
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TeamPokemonAdapter());
  }
  
  // Inicializar servicios
  await TeamService.init();
  await DatabaseService.isDatabaseReady();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pokédex App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
