import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ocorrencias.dart';

/// Classe responsável pela gerência do banco de dados SQLite
/// Implementa o padrão Singleton para garantir apenas uma instância
class DatabaseHelper {
  static const _databaseName = 'ocorrencias.db';
  static const _databaseVersion = 1;
  static const _tableName = 'ocorrencias';

  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  /// Getter para obter a instância do banco de dados
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Cria as tabelas do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  /// Insere uma nova ocorrência no banco de dados
  Future<int> insertOcorrencia(Ocorrencia ocorrencia) async {
    try {
      final db = await database;
      return await db.insert(
        _tableName,
        ocorrencia.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Erro ao inserir ocorrência: $e');
      rethrow;
    }
  }

  /// Busca todas as ocorrências do banco de dados
  Future<List<Ocorrencia>> fetchOcorrencias() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'id DESC', // Mais recentes primeiro
      );

      return List.generate(maps.length, (i) {
        return Ocorrencia.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erro ao buscar ocorrências: $e');
      rethrow;
    }
  }

  /// Busca uma ocorrência específica pelo ID
  Future<Ocorrencia?> getOcorrenciaById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return Ocorrencia.fromMap(maps.first);
    } catch (e) {
      print('Erro ao buscar ocorrência por ID: $e');
      rethrow;
    }
  }

  /// Atualiza uma ocorrência existente
  Future<int> updateOcorrencia(Ocorrencia ocorrencia) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        ocorrencia.toMap(),
        where: 'id = ?',
        whereArgs: [ocorrencia.id],
      );
    } catch (e) {
      print('Erro ao atualizar ocorrência: $e');
      rethrow;
    }
  }

  /// Deleta uma ocorrência pelo ID
  Future<int> deleteOcorrencia(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Erro ao deletar ocorrência: $e');
      rethrow;
    }
  }

  /// Deleta todas as ocorrências (útil para testes)
  Future<void> deleteAllOcorrencias() async {
    try {
      final db = await database;
      await db.delete(_tableName);
    } catch (e) {
      print('Erro ao deletar todas as ocorrências: $e');
      rethrow;
    }
  }

  /// Fecha a conexão com o banco de dados
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
