import 'package:sqflite/sqflite.dart';

import '../models/contract.dart';
import 'contract_database.dart';

class ContractRepository {
  ContractRepository(this._database);

  final ContractDatabase _database;

  Future<List<Contract>> buscarTodos() async {
    final Database db = await _database.database;
    final List<Map<String, dynamic>> rows = await db.query(
      'contracts',
      orderBy: 'start_date DESC',
    );
    return rows.map(Contract.fromMap).toList();
  }

  Future<int> inserir(Contract contract) async {
    final Database db = await _database.database;
    return db.insert('contracts', contract.toMap());
  }

  Future<void> atualizar(Contract contract) async {
    if (contract.id == null) {
      throw ArgumentError('Id do contrato nao pode ser nulo para atualizar');
    }
    final Database db = await _database.database;
    await db.update(
      'contracts',
      contract.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[contract.id],
    );
  }

  Future<void> remover(int id) async {
    final Database db = await _database.database;
    await db.delete('contracts', where: 'id = ?', whereArgs: <Object?>[id]);
  }
}
