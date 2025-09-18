import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'pokemon_team.db';
  static const int _databaseVersion = 1;

  // Tabla para movimientos de Pokémon
  static const String _pokemonMovesTable = 'pokemon_moves';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Crear tabla para movimientos de Pokémon
    await db.execute('''
      CREATE TABLE $_pokemonMovesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pokemon_id INTEGER NOT NULL,
        pokemon_name TEXT NOT NULL,
        move_1 TEXT,
        move_2 TEXT,
        move_3 TEXT,
        move_4 TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(pokemon_id)
      )
    ''');

    print('Database created successfully');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Manejar actualizaciones de la base de datos si es necesario
    if (oldVersion < newVersion) {
      // Aquí se pueden agregar migraciones futuras
      print('Database upgraded from version $oldVersion to $newVersion');
    }
  }

  // Guardar o actualizar movimientos de un Pokémon
  static Future<bool> savePokemonMoves({
    required int pokemonId,
    required String pokemonName,
    required List<String> moves,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();

      // Asegurar que tenemos máximo 4 movimientos
      final movesToSave = List<String?>.filled(4, null);
      for (int i = 0; i < moves.length && i < 4; i++) {
        movesToSave[i] = moves[i].isNotEmpty ? moves[i] : null;
      }

      final data = {
        'pokemon_id': pokemonId,
        'pokemon_name': pokemonName,
        'move_1': movesToSave[0],
        'move_2': movesToSave[1],
        'move_3': movesToSave[2],
        'move_4': movesToSave[3],
        'updated_at': now,
      };

      // Verificar si ya existe un registro para este Pokémon
      final existing = await db.query(
        _pokemonMovesTable,
        where: 'pokemon_id = ?',
        whereArgs: [pokemonId],
      );

      if (existing.isNotEmpty) {
        // Actualizar registro existente
        await db.update(
          _pokemonMovesTable,
          data,
          where: 'pokemon_id = ?',
          whereArgs: [pokemonId],
        );
        print('Updated moves for Pokémon $pokemonName (ID: $pokemonId)');
      } else {
        // Crear nuevo registro
        data['created_at'] = now;
        await db.insert(_pokemonMovesTable, data);
        print('Created new moves record for Pokémon $pokemonName (ID: $pokemonId)');
      }

      return true;
    } catch (e) {
      print('Error saving Pokémon moves: $e');
      return false;
    }
  }

  // Obtener movimientos de un Pokémon
  static Future<List<String>> getPokemonMoves(int pokemonId) async {
    try {
      final db = await database;
      final result = await db.query(
        _pokemonMovesTable,
        where: 'pokemon_id = ?',
        whereArgs: [pokemonId],
      );

      if (result.isNotEmpty) {
        final record = result.first;
        final moves = <String>[];
        
        for (int i = 1; i <= 4; i++) {
          final move = record['move_$i'] as String?;
          if (move != null && move.isNotEmpty) {
            moves.add(move);
          }
        }
        
        print('Retrieved ${moves.length} moves for Pokémon ID: $pokemonId');
        return moves;
      }

      print('No moves found for Pokémon ID: $pokemonId');
      return [];
    } catch (e) {
      print('Error getting Pokémon moves: $e');
      return [];
    }
  }

  // Eliminar movimientos de un Pokémon
  static Future<bool> deletePokemonMoves(int pokemonId) async {
    try {
      final db = await database;
      final deletedRows = await db.delete(
        _pokemonMovesTable,
        where: 'pokemon_id = ?',
        whereArgs: [pokemonId],
      );

      print('Deleted moves for Pokémon ID: $pokemonId (rows affected: $deletedRows)');
      return deletedRows > 0;
    } catch (e) {
      print('Error deleting Pokémon moves: $e');
      return false;
    }
  }

  // Obtener todos los Pokémon con movimientos guardados
  static Future<List<Map<String, dynamic>>> getAllPokemonWithMoves() async {
    try {
      final db = await database;
      final result = await db.query(
        _pokemonMovesTable,
        orderBy: 'updated_at DESC',
      );

      print('Retrieved ${result.length} Pokémon with saved moves');
      return result;
    } catch (e) {
      print('Error getting all Pokémon with moves: $e');
      return [];
    }
  }

  // Limpiar todos los movimientos guardados
  static Future<bool> clearAllMoves() async {
    try {
      final db = await database;
      final deletedRows = await db.delete(_pokemonMovesTable);
      
      print('Cleared all moves (rows affected: $deletedRows)');
      return true;
    } catch (e) {
      print('Error clearing all moves: $e');
      return false;
    }
  }

  // Obtener estadísticas de la base de datos
  static Future<Map<String, int>> getDatabaseStats() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_pokemonMovesTable');
      final count = result.first['count'] as int;

      return {
        'total_pokemon_with_moves': count,
      };
    } catch (e) {
      print('Error getting database stats: $e');
      return {'total_pokemon_with_moves': 0};
    }
  }

  // Cerrar la base de datos
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('Database closed');
    }
  }

  // Verificar si la base de datos existe y está funcionando
  static Future<bool> isDatabaseReady() async {
    try {
      final db = await database;
      await db.rawQuery('SELECT 1');
      return true;
    } catch (e) {
      print('Database not ready: $e');
      return false;
    }
  }

  // Método para debugging - obtener información de la tabla
  static Future<void> debugTableInfo() async {
    try {
      final db = await database;
      final tableInfo = await db.rawQuery('PRAGMA table_info($_pokemonMovesTable)');
      print('Table structure for $_pokemonMovesTable:');
      for (final column in tableInfo) {
        print('  ${column['name']}: ${column['type']} (nullable: ${column['notnull'] == 0})');
      }
    } catch (e) {
      print('Error getting table info: $e');
    }
  }
}