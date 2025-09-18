import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'views/main_navigation.dart';
import 'models/favorite_pokemon.dart';
import 'models/custom_move.dart';
import 'models/pokemon_custom_moves.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adaptadores
  Hive.registerAdapter(FavoritePokemonAdapter());
  Hive.registerAdapter(CustomMoveAdapter());
  Hive.registerAdapter(PokemonCustomMovesAdapter());
  
  runApp(const MyApp());
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
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
