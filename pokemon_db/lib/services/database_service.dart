import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'pokemon_attacks';

  // Obtener la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pokemon_attacks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Crear las tablas de la base de datos
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        pokemon_id INTEGER PRIMARY KEY,
        attacks TEXT NOT NULL
      )
    ''');
  }

  // Guardar ataques modificados de un Pokemon
  Future<void> saveCustomAttacks(int pokemonId, List<String> attacks) async {
    final db = await database;
    final attacksJson = attacks.join('|'); // Usar | como separador
    
    await db.insert(
      _tableName,
      {
        'pokemon_id': pokemonId,
        'attacks': attacksJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener ataques modificados de un Pokemon
  Future<List<String>?> getCustomAttacks(int pokemonId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );

    if (maps.isNotEmpty) {
      final attacksString = maps.first['attacks'] as String;
      return attacksString.split('|');
    }
    return null;
  }

  // Eliminar ataques modificados de un Pokemon
  Future<void> deleteCustomAttacks(int pokemonId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );
  }

  // Verificar si un Pokemon tiene ataques modificados
  Future<bool> hasCustomAttacks(int pokemonId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );
    return maps.isNotEmpty;
  }

  // Cerrar la base de datos
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}